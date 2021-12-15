# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Goteo
      module Api
        PROJECT_URL = "%{base_url}/projects/%{slug}"
        PROJECTS_URL = "%{base_url}/projects/?limit=%{limit}&page=%{page}"

        class << self
          def base_url
            "https://api.goteo.org/v1"
          end

          def project(slug)
            get format(PROJECT_URL, base_url: base_url, slug: slug)
          end

          # UNUSED
          def projects(limit = 10, page = 0)
            get format(PROJECT_URL, base_url: base_url, limit: limit, page: page)
          end

          def get(uri)
            verify_ssl = true
            connection ||= Faraday.new(ssl: { verify: verify_ssl }) do |conn|
              conn.request :basic_auth, ENV["GOTEO_USERNAME"], ENV["GOTEO_PASSWORD"]
            end

            response = connection.get uri

            raise Error, response.reason_phrase unless response.success? || response.status == 404

            JSON.parse(response.body).to_h
          end
        end

        class Error < StandardError; end
      end
    end
  end
end
