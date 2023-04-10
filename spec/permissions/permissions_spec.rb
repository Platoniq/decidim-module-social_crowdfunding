# frozen_string_literal: true

require "spec_helper"

module Decidim::SocialCrowdfunding
  describe Permissions do
    subject { described_class.new(user, permission_action, context).permissions.allowed? }

    let(:organization) { create :organization }
    let(:user) { create :user, organization: organization }
    let(:context) do
      {
        current_organization: organization,
        campaign: campaign
      }
    end
    let(:campaign) { create :campaign }
    let(:permission_action) { Decidim::PermissionAction.new(**action) }
    let(:action) do
      { scope: :public, action: :show, subject: :campaign }
    end

    context "when scope is admin" do
      let(:action) do
        { scope: :admin, action: :show, subject: :campaign }
      end

      it_behaves_like "permission is not set"
    end

    context "when no user present" do
      let(:user) { nil }

      it { is_expected.to be true }
    end

    context "when user is not an admin" do
      it { is_expected.to be true }
    end

    context "when user is an admin" do
      let(:user) { create :user, :admin, organization: organization }

      it { is_expected.to be true }
    end
  end
end
