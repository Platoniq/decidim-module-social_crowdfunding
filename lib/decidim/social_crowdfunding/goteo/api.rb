# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Goteo
      module Api
        class << self
          def get_token(email, password)
            verify_ssl = true
            connection ||= Faraday.new(ssl: { verify: verify_ssl }) do |conn|
              conn.headers["Content-Type"] = "application/json"
            end

            connection.post("#{Goteo.api_url}/user_tokens") do |req|
              req.body = credentials(email, password)
            end
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

          def validate_token(id, token)
            verify_ssl = true
            connection ||= Faraday.new(ssl: { verify: verify_ssl }) do |conn|
              conn.headers["Authorization"] = "Bearer #{token}"
            end

            connection.get("#{Goteo.api_url}/user_tokens/#{id}")
          end

          private

          def get_request(endpoint, id, goteo_token, locale = nil)
            verify_ssl = true
            connection ||= Faraday.new(ssl: { verify: verify_ssl }) do |conn|
              conn.headers["Authorization"] = "Bearer #{goteo_token}"
              conn.headers["Accept-Language"] = locale
            end

            response = connection.get("#{Goteo.api_url}/#{endpoint}/#{id}")

            raise Error, response.reason_phrase unless response.success? || response.status == 404

            JSON.parse(response.body).to_h
          end

          def credentials(email, password)
            {
              identifier: email,
              password:
            }.to_json
          end
        end

        class Error < StandardError; end
      end
    end
  end
end
