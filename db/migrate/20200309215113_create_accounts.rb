class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts, id: false do |t|
      t.string :account_id, primary_key: true, null: false, unique: true, index: true
      t.string :account_name
      t.string :account_contact
      t.string :contact_email, unique: true, null: false, index: true
      t.integer :site_count
      t.boolean :deactivated_all_campaigns, default: false
      t.integer :last_30_day_active_count
      t.integer :last_7_day_budget_total
      t.integer :total_active
      t.integer :total_mobile_campaign
      t.boolean :twitter_connected, default: false
      t.integer :ads_sized_320x50
      t.integer :ads_sized_320x480
      t.integer :ads_sized_480x320
      t.integer :ads_sized_300x250
      t.integer :ads_sized_300x600
      t.integer :ads_sized_728x90
      t.integer :ads_sized_970x250
      t.integer :last_30_day_clicks
      t.integer :last_30_day_conversions
      t.float :last_30_day_costs
      t.integer :last_30_day_impressions
      t.boolean :hubspot, default: false
      t.integer :sidebar_campaigns_count
      t.integer :web_campaigns_count
      t.integer :dynamic_web_campaigns_count
      t.integer :segments_count
      t.boolean :tag_found, default: false
      t.integer :ads_count
      t.integer :total_campaigns
      t.boolean :shsp_account, default: false
      t.boolean :pa_account, default: false
      t.integer :conversions_count
      t.float :lifetime_spend
      t.datetime :acc_created_at
      t.integer :newsfeed_campaign_count
      t.float :budget
      t.integer :public_data_campaigns
      t.boolean :dynamic_banners, default: false
      t.integer :trailing_uniques
      t.integer :total_clicks
      t.integer :total_conversions
      t.boolean :tracking_mobile, default: false
      t.boolean :mobile_beta, default: false
      t.boolean :profile_access, default: false
      t.boolean :fb_setup, default: false
      t.boolean :created_report, default: false
      t.boolean :has_customer_audience, default: false
      t.boolean :is_invoiced, default: false
      t.boolean :on_click_funnel, default: false

      t.timestamps
    end
  end
end
