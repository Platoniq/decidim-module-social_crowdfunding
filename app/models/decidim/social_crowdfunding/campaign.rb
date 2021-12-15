# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    # The data store for a Campaign in the Decidim::SocialCrowdfunding component.

    # https://github.com/GoteoFoundation/goteo/blob/live/src/Goteo/Model/Project.php
    class Campaign < ApplicationRecord
      # enum status: %i[editing reviewing in_campaign funded fulfilled unfunded]

      include Decidim::Traceable
      include Decidim::Loggable

      self.table_name = :decidim_social_crowdfunding_campaigns

      belongs_to :organization, foreign_key: :decidim_organization_id, class_name: "Decidim::Organization"

      def self.translate_attribute(json, key)
        translated = { json["lang"] => json[key] }

        json["translations"].keys.each do |lang|
          translated[lang] = json["translations"][lang][key]
        end

        translated
      end

      def self.params_from_json(json)
        {
          name: translate_attribute(json, "name"),
          description: translate_attribute(json, "description"),
          url: json["project-url"],
          thumbnail_url: json["image-url"],

          amount: json["amount"],
          minimum: json["minimum"],
          optimum: json["optimum"],

          data: json
        }
      end

      def self.fetch(slug, component, sync: false)
        campaign = find_by(slug: slug, organization: component.organization)

        fetch_api = campaign.blank? || sync || should_sync?(campaign, component)

        if fetch_api
          json = Goteo::Api.project(slug, component)

          return nil if json["error"] == 404

          if campaign.present?
            campaign.update!(params_from_json(json))
          else
            campaign = create!(params_from_json(json).merge(slug: slug, organization: component.organization))
          end
        end

        campaign
      end

      def self.should_sync?(campaign, component)
        campaign.created_at < 1.minute.ago || campaign.updated_at > component.settings.goteo_api_update_hours.hours.ago
      end

      def costs
        @costs ||= translated_array("costs")
      end

      def needs
        @needs ||= translated_array("needs")
      end

      def rewards
        @rewards ||= translated_array("rewards").select { |r| r["type"] == "individual" }
      end

      def social_commitments
        @social_commitments ||= translated_array("rewards").select { |r| r["type"] == "social" }
      end

      def base_language
        @base_language ||= data["lang"]
      end

      def translations
        @translations ||= data["translations"]
      end

      def translated_languages
        @translated_languages ||= translations.keys
      end

      def translated_attribute(key)
        translated_attribute = { base_language => value }

        translated_languages.each do |lang|
          translated_attribute[lang] = translations[lang][key]
        end
      end

      def translated_array(array_name)
        return if data[array_name].blank?

        data[array_name].map do |object|
          id = object["id"]

          translated_object = {}

          object.each_pair do |key, value|
            if value.is_a? String
              translated_object[key] = { base_language => value }

              translated_languages.each do |lang|
                value = translations.dig(lang, array_name, id.to_s, key)

                next unless value

                translated_object[key][lang] = value
              end
            else
              translated_object[key] = value
            end
          end
        end
      end

      def can_donate?
        data["status"] == "in_campaign"
      end
    end
  end
end
