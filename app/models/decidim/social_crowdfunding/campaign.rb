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

      def self.params_from_json(json, costs, rewards)
        {
          name: json["title"],
          description: json["description"],

          amount: json["balance"]["amount"],
          minimum: json["budget"]["minimum"]["money"]["amount"],
          optimum: json["budget"]["optimum"]["money"]["amount"],

          costs:,
          rewards:,
          data: json
        }
      end

      def self.fetch(id, goteo_config, component, sync: false)
        campaign = find_by(id:, organization: component.organization)

        fetch_api = campaign.blank? || sync || should_sync?(campaign, component)

        if fetch_api
          project = Goteo::Api.get_project(id, goteo_config)

          return nil if project["error"] == 404

          project_info = fetch_project_translations(project, goteo_config)

          accounting_id = extract_id(project_info["accounting"])

          project_balance = Goteo::Api.get_accounting(accounting_id, goteo_config)

          return nil if project_balance["error"] == 404

          project_info["balance"] = project_balance["balance"]

          costs = fetch_costs(project_info["locales"], project_info["budgetItems"], goteo_config)

          rewards = fetch_rewards(project_info["locales"], project_info["rewards"], goteo_config)

          if campaign.present?
            campaign.update!(params_from_json(project_info, costs, rewards))
          else
            campaign = create!(params_from_json(project_info, costs, rewards).merge(organization: component.organization))
          end
        end

        campaign
      end

      def self.should_sync?(campaign, component)
        campaign.updated_at > component.settings.goteo_api_update_hours.hours.ago
      end

      def self.fetch_costs(locales, costs_urls, goteo_config)
        locales.index_with do |locale|
          costs_urls.map { |url| Goteo::Api.get_cost(extract_id(url), goteo_config, locale) }
        end
      end

      def self.fetch_rewards(locales, rewards_urls, goteo_config)
        locales.index_with do |locale|
          rewards_urls.map { |url| Goteo::Api.get_reward(extract_id(url), goteo_config, locale) }
        end
      end

      def self.fetch_project_translations(project, goteo_config)
        fields = %w(title subtitle description)

        fields.each do |key|
          project[key] = {}
        end

        project["locales"].each do |locale|
          translated_info = Goteo::Api.get_project(project["id"], goteo_config, locale)

          fields.each do |key|
            project[key][locale] = translated_info[key]
          end
        end

        project
      end

      def can_donate?
        data["status"] == "in_campaign"
      end

      def self.extract_id(url)
        url.match(%r{/(\d+)$})[1].to_i
      end
    end
  end
end
