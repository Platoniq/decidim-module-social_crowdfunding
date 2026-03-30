class UpdateDecidimSocialCrowdfundingCampaigns < ActiveRecord::Migration[7.0]
  def change
    remove_column :decidim_social_crowdfunding_campaigns, :lang
    remove_column :decidim_social_crowdfunding_campaigns, :thumbnail_url

    add_column :decidim_social_crowdfunding_campaigns, :costs, :jsonb
    add_column :decidim_social_crowdfunding_campaigns, :rewards, :jsonb
  end
end
