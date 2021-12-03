# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    # This is the engine that runs on the public interface of `SocialCrowdfunding`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::SocialCrowdfunding::Admin

      paths["lib/tasks"] = nil
      paths["db/migrate"] = nil

      routes do
        # Add admin engine routes here

        resources :campaigns, only: [:destroy, :update]

        root to: "campaigns#index"
      end
    end
  end
end
