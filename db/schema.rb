# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_20_201912) do

  create_table "accounts", primary_key: "account_id", id: :string, force: :cascade do |t|
    t.string "account_name"
    t.string "account_contact"
    t.string "contact_email", null: false
    t.integer "site_count"
    t.boolean "deactivated_all_campaigns", default: false
    t.integer "last_30_day_active_count"
    t.integer "last_7_day_budget_total"
    t.integer "total_active"
    t.integer "total_mobile_campaign"
    t.boolean "twitter_connected", default: false
    t.integer "ads_sized_320x50"
    t.integer "ads_sized_320x480"
    t.integer "ads_sized_480x320"
    t.integer "ads_sized_300x250"
    t.integer "ads_sized_300x600"
    t.integer "ads_sized_728x90"
    t.integer "ads_sized_970x250"
    t.integer "last_30_day_clicks"
    t.integer "last_30_day_conversions"
    t.float "last_30_day_costs"
    t.integer "last_30_day_impressions"
    t.boolean "hubspot", default: false
    t.integer "sidebar_campaigns_count"
    t.integer "web_campaigns_count"
    t.integer "dynamic_web_campaigns_count"
    t.integer "segments_count"
    t.boolean "tag_found", default: false
    t.integer "ads_count"
    t.integer "total_campaigns"
    t.boolean "shsp_account", default: false
    t.boolean "pa_account", default: false
    t.integer "conversions_count"
    t.float "lifetime_spend"
    t.datetime "acc_created_at"
    t.integer "newsfeed_campaign_count"
    t.float "budget"
    t.integer "public_data_campaigns"
    t.boolean "dynamic_banners", default: false
    t.integer "trailing_uniques"
    t.integer "total_clicks"
    t.integer "total_conversions"
    t.boolean "tracking_mobile", default: false
    t.boolean "mobile_beta", default: false
    t.boolean "profile_access", default: false
    t.boolean "fb_setup", default: false
    t.boolean "created_report", default: false
    t.boolean "has_customer_audience", default: false
    t.boolean "is_invoiced", default: false
    t.boolean "on_click_funnel", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "has_stripe", default: false
    t.boolean "amf_active", default: false
    t.index ["account_id"], name: "index_accounts_on_account_id"
    t.index ["contact_email"], name: "index_accounts_on_contact_email"
  end

end
