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
          slug: json["slug"],

          amount: json["balance"]["amount"],
          minimum: json["budget"]["minimum"]["money"]["amount"],
          optimum: json["budget"]["optimum"]["money"]["amount"],

          costs:,
          rewards:,
          data: json
        }
      end

      def self.fetch(slug, goteo_token, component, sync: false)
        campaign = find_by(slug:, organization: component.organization)

        fetch_api = campaign.blank? || sync || should_sync?(campaign, component)

        if fetch_api
          project = Goteo::Api.get_project(slug, goteo_token)

          return nil if project["status"] == 404

          project_info = fetch_project_translations(project, goteo_token)

          accounting_id = extract_id(project_info["accounting"])

          project_balance = Goteo::Api.get_accounting(accounting_id, goteo_token)

          return nil if project_balance["status"] == 404

          project_info["balance"] = project_balance["balance"]

          costs = fetch_costs(project_info["locales"], project_info["budgetItems"], goteo_token)

          rewards = fetch_rewards(project_info["locales"], project_info["rewards"], goteo_token)

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

      def self.fetch_costs(locales, costs_urls, goteo_token)
        locales.index_with do |locale|
          costs_urls.map { |url| Goteo::Api.get_cost(extract_id(url), goteo_token, locale) }
        end
      end

      def self.fetch_rewards(locales, rewards_urls, goteo_token)
        locales.index_with do |locale|
          rewards_urls.map { |url| Goteo::Api.get_reward(extract_id(url), goteo_token, locale) }
        end
      end

      def self.fetch_project_translations(project, goteo_token)
        fields = %w(title subtitle description)

        fields.each do |key|
          project[key] = {}
        end

        project["locales"].each do |locale|
          translated_info = Goteo::Api.get_project(project["slug"], goteo_token, locale)

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
