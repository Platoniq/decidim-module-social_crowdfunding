# frozen_string_literal: true

require "decidim/social_crowdfunding/goteo/api"

module Decidim
  module SocialCrowdfunding
    module Goteo
      class << self
        def base_url
          "https://goteo.org/"
        end

        def build_url(path, params = {})
          uri = URI.join(base_url, path)
          uri.query = params.keys.map { |k| "#{k}=#{params[k]}" }.join("&")
          uri.to_s
        end

        def reward_url(campaign, reward)
          build_url("/invest/#{campaign.slug}/payment", reward: reward["id"])
        end

        def create_campaign_url
          build_url("https://goteo.org/project/create?lang=#{I18n.locale}")
        end
      end
    end
  end
end
