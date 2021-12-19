# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    class CampaignsController < Decidim::SocialCrowdfunding::ApplicationController
      helper CampaignHelper

      include ThermometerHelper

      def show
        enforce_permission_to :show, :campaign, campaign: current_campaign

        @thermometer_params = thermometer_params
      end
    end
  end
end
