# frozen_string_literal: true

class CreateDecidimSocialCrowdfundingCampaigns < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_social_crowdfunding_campaigns do |t|
      t.jsonb :name
      t.jsonb :description
      
      t.string :url
      t.string :lang

      t.string :thumbnail_url
      
      t.decimal :amount
      t.decimal :minimum
      t.decimal :optimum

      t.jsonb :data

      t.timestamps
    end
  end
end
