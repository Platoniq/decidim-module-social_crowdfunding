class CreateGoteoConfigurations < ActiveRecord::Migration[7.0]
  def change
    create_table :goteo_configurations do |t|
      t.references :decidim_organization, foreign_key: { to_table: :decidim_organizations }, index: { name: "index_social_crowdfunding_goteo_configurations_on_organization" }

      t.string :client_id
      t.string :client_secret
      t.string :token
      t.datetime :token_expires_at

      t.timestamps
    end
  end
end
