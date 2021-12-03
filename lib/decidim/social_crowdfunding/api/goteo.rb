# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Api
      module Goteo
        PROJECT_URL = "https://api.goteo.org/v1/projects/%{slug}"
        PROJECTS_URL = "https://api.goteo.org/v1/projects"

        class << self
          def base_url
            "https://goteo.org"
          end

          def get_project(slug)
            get format(PROJECT_URL, slug: slug)
          end

          def get_projects
            get PROJECT_URL
          end

          def get(uri)
            verify_ssl = true
            connection ||= Faraday.new(ssl: { verify: verify_ssl }) do |conn|
              # conn.request :basic_auth, "user", "pass"
              conn.request :basic_auth, "ivan", "master"
            end

            response = connection.get uri

            raise Error, response.reason_phrase unless response.success?

            JSON.parse(response.body).to_h
          end
        end

        class Error < StandardError; end
      end
    end
  end
end
