# frozen_string_literal: true

require "decidim/social_crowdfunding/goteo/api"

module Decidim
  module SocialCrowdfunding
    module Goteo
      mattr_accessor :api_credentials, default: {
        username: ENV.fetch("GOTEO_API_USERNAME", ""),
        key: ENV.fetch("GOTEO_API_KEY", "")
      }
      mattr_accessor :api_url, default: ENV.fetch("GOTEO_API_URL", "https://api.goteo.org/v1")
      mattr_accessor :base_url, default: ENV.fetch("GOTEO_BASE_URL", "https://goteo.org/")

      class << self
        def config = self

        def configure
          yield self
        end

        def build_url(path, params = {})
          uri = URI.join(base_url, path)
          uri.query = params.keys.map { |k| "#{k}=#{params[k]}" }.join("&")
          uri.to_s
        end

        def participate_url(campaign)
          build_url("/project/#{campaign.slug}/participate#collapseOne")
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
