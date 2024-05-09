# frozen_string_literal: true

require "spec_helper"

describe "Visit the home page", :perform_enqueued do
  let(:organization) { create(:organization, available_locales: [:en]) }

  before do
    switch_to_host(organization.host)
    visit decidim.root_path
  end

  it "renders the home page" do
    expect(page).to have_content("Home")
  end
end
