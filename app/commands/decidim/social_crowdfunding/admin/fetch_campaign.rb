# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Admin
      # A command with all the business logic when retrieving info from campaign
      class FetchCampaign < Rectify::Command
        def initialize(slug)
          campaign_data = Decidim::SocialCrowdfunding::Api::Goteo.get_project(slug)
          @campaign = Decidim::SocialCrowdfunding::Campaign.new(campaign_data)
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
      end
    end
  end
end
