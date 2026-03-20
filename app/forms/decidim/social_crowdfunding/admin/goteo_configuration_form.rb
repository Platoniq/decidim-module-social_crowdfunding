# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Admin
      class GoteoConfigurationForm < Decidim::Form
        attribute :client_id, String
        attribute :client_secret, String

        validates :client_id, :client_secret, presence: true
      end
    end
  end
end
