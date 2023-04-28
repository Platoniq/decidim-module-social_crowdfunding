# frozen_string_literal: true

require "spec_helper"

module Decidim::SocialCrowdfunding::Admin
  describe Permissions do
    subject { described_class.new(user, permission_action, context).permissions.allowed? }

    let(:organization) { create :organization }
    let(:user) { create :user, :admin, organization: organization }
    let(:context) do
      {
        current_organization: organization,
        current_campaign: campaign
      }
    end
    let(:campaign) { create :campaign }
    let(:action) do
      { scope: :admin, action: :update, subject: campaign }
    end
    let(:permission_action) { Decidim::PermissionAction.new(**action) }

    context "when scope is not admin" do
      let(:action) do
        { scope: :foo, action: :update, subject: :some_subject }
      end

      it_behaves_like "permission is not set"
    end

    context "when action is set" do
      context "when action is index" do
        let(:action) do
          { scope: :admin, action: :index, subject: :campaigns }
        end

        it { is_expected.to be true }
      end

      context "when action is update" do
        let(:action) do
          { scope: :admin, action: :update, subject: :campaign }
        end

        it { is_expected.to be true }
      end

      context "when action is destroy" do
        let(:action) do
          { scope: :admin, action: :destroy, subject: :campaign }
        end

        it { is_expected.to be true }
      end
    end
  end
end
