# frozen_string_literal: true

module Decidim
  module SocialCrowdfunding
    # This is the engine that runs on the public interface of `SocialCrowdfunding`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::SocialCrowdfunding::Admin

      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        root to: "campaigns#show"
      end
    end
  end
end
