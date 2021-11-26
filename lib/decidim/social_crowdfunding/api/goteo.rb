# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Api
      module Goteo
        PROJECT_URL = "https://api.goteo.org/v1/projects/%{slug}"

        class << self
          def get_project(slug)
            verify_ssl = true
            connection ||= Faraday.new(ssl: { verify: verify_ssl }) do |conn|
              conn.request :basic_auth, "user", "pass"
            end

            response = connection.get URI.join(format(PROJECT_URL, slug: slug))

            raise Error, response.reason_phrase unless response.success?

            JSON.parse(response.body).to_h
          end
        end

        class Error < StandardError; end
      end
    end
  end
end
