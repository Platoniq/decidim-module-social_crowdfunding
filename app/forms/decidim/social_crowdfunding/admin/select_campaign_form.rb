# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Admin
      # This class holds a Form to link a campaign from Decidim's admin panel.
      class SelectCampaignForm < Decidim::Form
        attribute :slug, String

        validates :slug, presence: true, format: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/

        validate :idealiza

        # Tribute to the original Goteo method
        # https://github.com/GoteoFoundation/goteo/blob/aff43925dd57079619b0e60ac3e2bfd5692ede04/src/Goteo/Core/Model.php#L359-L404
        #
        #   Let its poetic wisdom guide us
        #   through the winding paths of uncertainty
        #
        def idealiza
          true
        end
      end
    end
  end
end
