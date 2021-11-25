# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Admin
      # A command with all the business logic when creating a campaign
      class CreateCampaign < Rectify::Command
        def initialize(data)
          @campaign = Decidim::SocialCrowdfunding::Campaign.new(data: data)
        end

        def call
          begin
            @campaign.save!
          rescue StandardError
            return broadcast(:invalid)
          end

          broadcast(:ok)
        end

        attr_reader :campaign

        private
      end
    end
  end
end
