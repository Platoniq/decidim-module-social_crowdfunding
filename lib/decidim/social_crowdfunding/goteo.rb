# frozen_string_literal: true

require "decidim/social_crowdfunding/goteo/api"

module Decidim
  module SocialCrowdfunding
    module Goteo
      include ActiveSupport::Configurable

      # setup default API credentials
      config_accessor :api_credentials do
        {
          username: ENV.fetch("GOTEO_API_USERNAME", ""),
          key: ENV.fetch("GOTEO_API_KEY", "")
        }
      end

      # setup API base url
      config_accessor :api_url do
        ENV.fetch("GOTEO_API_URL", "https://api.goteo.org/v1")
      end

      # setup base url
      config_accessor :base_url do
        ENV.fetch("GOTEO_BASE_URL", "https://goteo.org/")
      end

      class << self
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
