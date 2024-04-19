# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Goteo
      module Api
        PROJECT_URL = "%{api_url}/projects/%{slug}"

        class << self
          def project(slug, component)
            get(format(PROJECT_URL, api_url: api_url(component), slug:), component)
          end

          private

          def get(uri, component)
            verify_ssl = true

            connection ||= Faraday.new(ssl: { verify: verify_ssl }) do |conn|
              conn.request :authorization, :basic, api_username(component), api_key(component)
            end

            response = connection.get(uri)

            raise Error, response.reason_phrase unless response.success? || response.status == 404

            JSON.parse(response.body).to_h
          end

          def api_username(component)
            component.settings.goteo_api_username.presence || Goteo.api_credentials[:username]
          end

          def api_key(component)
            component.settings.goteo_api_key.presence || Goteo.api_credentials[:key]
          end

          def api_url(component)
            component.settings.goteo_api_url.presence || Goteo.api_url
          end
        end

        class Error < StandardError; end
      end
    end
  end
end
