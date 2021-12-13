# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    class CampaignsController < Decidim::SocialCrowdfunding::ApplicationController
      helper CampaignHelper
      helper ThermometerHelper

      def show; end
    end
  end
end
