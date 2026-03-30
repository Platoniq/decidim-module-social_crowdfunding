# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Goteo
      module Api
        class << self
          def fetch_oauth_token(client_id, client_secret)
            connection = Faraday.new(ssl: { verify: true })

            response = connection.post("#{Goteo.api_url}/oauth/token") do |req|
              req.headers["Content-Type"] = "application/x-www-form-urlencoded"
              req.body = URI.encode_www_form(
                grant_type: "client_credentials",
                client_id:,
                client_secret:
              )
            end

            raise Error, response.reason_phrase unless response.success?

            JSON.parse(response.body)
          end

          def get_project(slug, goteo_token, locale = "en")
            get_request("projects", slug, goteo_token, locale)
          end

          def get_accounting(id, goteo_token)
            get_request("accountings", id, goteo_token)
          end

          def get_cost(id, goteo_token, locale)
            get_request("project_budget_items", id, goteo_token, locale)
          end

          def get_reward(id, goteo_token, locale)
            get_request("project_rewards", id, goteo_token, locale)
          end

          private

          def get_request(endpoint, id, goteo_token, locale = nil)
            connection = Faraday.new(ssl: { verify: true }) do |conn|
              conn.headers["Authorization"] = "Bearer #{goteo_token}"
              conn.headers["Accept-Language"] = locale
            end

            response = connection.get("#{Goteo.api_url}/v4/#{endpoint}/#{id}")

            raise Error, response.reason_phrase unless response.success? || response.status == 404

            JSON.parse(response.body).to_h
          end
        end

        class Error < StandardError; end
      end
    end
  end
end
