# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Admin
      # This class holds a Form to link a campaign from Decidim's admin panel.
      class CampaignForm < Decidim::Form
        include TranslatableAttributes

        mimic :campaign

        validates :id, presence: true
      end
    end
  end
end
