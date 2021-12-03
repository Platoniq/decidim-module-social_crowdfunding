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

      def self.fetch(slug, organization)
        campaign = find_or_create_by(slug: slug, organization: organization)

        json = Api::Goteo.get_project(slug)

        campaign.update!(params_from_json(json)) if campaign.created_at < 1.minute.ago || campaign.updated_at > 1.day.ago

        campaign
      end

      def can_donate?
        data["status"] == "in_campaign"
      end
    end
  end
end
