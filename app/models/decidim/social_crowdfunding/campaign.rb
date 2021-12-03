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

      def self.params_from_json(json)
        lang = json["lang"]

        {
          name: {
            lang => json["name"]
          },
          description: {
            lang => json["description"]
          },
          url: json["project-url"],
          thumbnail_url: json["image-url"],

          amount: json["amount"],
          minimum: json["minimum"],
          optimum: json["optimum"],

          data: json
        }
      end

      def self.fetch(slug, organization, sync: false)
        campaign = find_or_create_by(slug: slug, organization: organization)

        if sync || campaign.should_sync?
          json = Api::Goteo.project(slug)
          campaign.update!(params_from_json(json))
        end

        campaign
      end

      def can_donate?
        data["status"] == "in_campaign"
      end

      def should_sync?
        created_at < 1.minute.ago || updated_at > 1.day.ago
      end
    end
  end
end
