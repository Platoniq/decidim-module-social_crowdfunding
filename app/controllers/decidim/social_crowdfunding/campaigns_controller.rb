# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    class CampaignsController < Decidim::SocialCrowdfunding::ApplicationController
      helper CampaignHelper
      include ThermometerHelper

      def show
        @thermometer_params = thermometer_params
      end
    end
  end
end
