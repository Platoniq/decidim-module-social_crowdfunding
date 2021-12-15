# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Goteo
      module Api
        PROJECT_URL = "%{base_url}/projects/%{slug}"

        class << self
          def base_url
            ENV.fetch("GOTEO_BASE_URL", "https://api.goteo.org/v1")
          end

          def project(slug, component)
            get(format(PROJECT_URL, base_url: base_url, slug: slug), component)
          end

          private

          def get(uri, component)
            verify_ssl = true

            connection ||= Faraday.new(ssl: { verify: verify_ssl }) do |conn|
              conn.request :basic_auth, api_username(component), api_key(component)
            end

            response = connection.get(uri)

            raise Error, response.reason_phrase unless response.success? || response.status == 404

            JSON.parse(response.body).to_h
          end

          def api_username(component)
            component.settings.goteo_api_username.presence || ENV["GOTEO_API_USERNAME"]
          end

          def api_key(component)
            component.settings.goteo_api_key.presence || ENV["GOTEO_API_KEY"]
          end
        end

        class Error < StandardError; end
      end
    end
  end
end
