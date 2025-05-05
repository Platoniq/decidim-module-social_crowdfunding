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

            response = connection.post("#{Goteo.api_url}/user_tokens") do |req|
              req.body = credentials(email, password)
            end

            raise Error, response.reason_phrase unless response.success? || response.status == 404

            JSON.parse(response.body).to_h
          end

          def get_project(id, goteo_config, locale = "en")
            verify_ssl = true
            connection ||= Faraday.new(ssl: { verify: verify_ssl }) do |conn|
              conn.headers["Authorization"] = "Bearer #{goteo_config.token}"
              conn.headers["Accept-Language"] = locale
            end

            response = connection.get("#{Goteo.api_url}/projects/#{id}")

            raise Error, response.reason_phrase unless response.success? || response.status == 404

            JSON.parse(response.body).to_h
          end

          def get_accounting(id, goteo_config)
            verify_ssl = true
            connection ||= Faraday.new(ssl: { verify: verify_ssl }) do |conn|
              conn.headers["Authorization"] = "Bearer #{goteo_config.token}"
            end

            response = connection.get("#{Goteo.api_url}/accountings/#{id}")

            raise Error, response.reason_phrase unless response.success? || response.status == 404

            JSON.parse(response.body).to_h
          end

          def get_cost(id, goteo_config, locale)
            verify_ssl = true
            connection ||= Faraday.new(ssl: { verify: verify_ssl }) do |conn|
              conn.headers["Authorization"] = "Bearer #{goteo_config.token}"
              conn.headers["Accept-Language"] = locale
            end

            response = connection.get("#{Goteo.api_url}/project_budget_items/#{id}")

            raise Error, response.reason_phrase unless response.success? || response.status == 404

            JSON.parse(response.body).to_h
          end

          def get_reward(id, goteo_config, locale)
            verify_ssl = true
            connection ||= Faraday.new(ssl: { verify: verify_ssl }) do |conn|
              conn.headers["Authorization"] = "Bearer #{goteo_config.token}"
              conn.headers["Accept-Language"] = locale
            end

            response = connection.get("#{Goteo.api_url}/project_rewards/#{id}")

            raise Error, response.reason_phrase unless response.success? || response.status == 404

            JSON.parse(response.body).to_h
          end

          def validate_token(id, token)
            verify_ssl = true
            connection ||= Faraday.new(ssl: { verify: verify_ssl }) do |conn|
              conn.headers["Authorization"] = "Bearer #{token}"
            end

            connection.get("#{Goteo.api_url}/user_tokens/#{id}")
          end

          private

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
