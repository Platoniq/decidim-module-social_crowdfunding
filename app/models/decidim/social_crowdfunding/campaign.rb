# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    # The data store for a Campaign in the Decidim::SocialCrowdfunding component.
    class Campaign < ApplicationRecord
      include Decidim::Traceable
      include Decidim::Loggable

      self.table_name = :decidim_social_crowdfunding_campaigns

      belongs_to :organization, class_name: "Decidim::Organization"

      def self.from_json(json)
        lang = json["lang"]

        params = {
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

        self.create!(params)
      end
    end
  end
end
