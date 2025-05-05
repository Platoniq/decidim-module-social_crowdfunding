class CreateGoteoConfigurations < ActiveRecord::Migration[7.0]
  def change
    create_table :goteo_configurations do |t|
      t.references :decidim_organization, foreign_key: { to_table: :decidim_organizations }, index: { name: "index_social_crowdfunding_goteo_configurations_on_organization" }

      t.integer :goteo_uid

      t.string :email
      t.string :password
      t.string :token

      t.timestamps
    end
  end
end
