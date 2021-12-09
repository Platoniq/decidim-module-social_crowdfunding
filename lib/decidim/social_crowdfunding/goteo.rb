# frozen_string_literal: true

require "decidim/social_crowdfunding/goteo/api"

module Decidim
  module SocialCrowdfunding
    module Goteo
      REWARD_URL = "%{base_url}/invest/%{campaign_id}/payment?reward=%{reward_id}"

      class << self
        def base_url
          "https://goteo.org"
        end

        def reward_url(campaign, reward)
          format(REWARD_URL, base_url: base_url, campaign_id: campaign.slug, reward_id: reward["id"])
        end
      end
    end
  end
end
