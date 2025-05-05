# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    module Admin
      # A command with the business logic for linking a Goteo account with a decidim user
      class CreateGoteoConfiguration < Decidim::Command
        # Public: Initializes the command.
        #
        # form         - A form object with the params.
        # current_user - The current user.
        def initialize(form, current_user)
          @form = form
          @current_user = current_user
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid, together with the follow.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          authenticate!

          broadcast(:ok)
        end

        private

        attr_reader :form, :current_user

        def authenticate!
          response = Goteo::Api.get_token(form.email, form.password)

          @goteo_config = GoteoConfiguration.find_or_create_by(email: form.email)

          @goteo_config.update!(
            goteo_uid: response["id"],
            password: form.password,
            token: response["token"],
            organization: current_organization
          )
        end
      end
    end
  end
end
