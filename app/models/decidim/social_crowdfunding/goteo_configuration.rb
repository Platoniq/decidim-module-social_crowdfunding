# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    class GoteoConfiguration < ApplicationRecord
      include Decidim::RecordEncryptor

      self.table_name = "goteo_configurations"

      belongs_to :organization, foreign_key: :decidim_organization_id, class_name: "Decidim::Organization"

      encrypt_attribute :password, type: :string
      encrypt_attribute :token, type: :string

      def token_valid?
        response = Goteo::Api.validate_token(goteo_uid, token)

        response.success?
      end

      def update_token
        response = Goteo::Api.get_token(email, password)

        update(goteo_uid: response["id"], token: response["token"])
      end
    end
  end
end
