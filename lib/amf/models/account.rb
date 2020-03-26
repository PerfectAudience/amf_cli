# frozen_string_literal: true

module AMF
  class Account
    include Mongoid::Document

    validates :account_id, presence: true
    validates :contact_email, presence: true, uniqueness: {case_insensitive: true}

    field :account_id, type: String
    field :account_name, type: String
    field :account_contact, type: String
    field :contact_email, type: String
    field :site_count, type: Integer
    field :deactivated_all_campaigns, type: Boolean, default: false
    field :last_30_day_active_count, type: Integer
    field :last_7_day_budget_total, type: Integer
    field :total_active, type: Integer
    field :total_mobile_campaign, type: Integer
    field :twitter_connected, type: Boolean, default: false
    field :ads_sized_320x50, type: Integer
    field :ads_sized_320x480, type: Integer
    field :ads_sized_480x320, type: Integer
    field :ads_sized_300x250, type: Integer
    field :ads_sized_300x600, type: Integer
    field :ads_sized_728x90, type: Integer
    field :ads_sized_970x250, type: Integer
    field :last_30_day_clicks, type: Integer
    field :last_30_day_conversions, type: Integer
    field :last_30_day_costs, type: Float
    field :last_30_day_impressions, type: Integer
    field :hubspot, type: Boolean, default: false
    field :sidebar_campaigns_count, type: Integer
    field :web_campaigns_count, type: Integer
    field :dynamic_web_campaigns_count, type: Integer
    field :segments_count, type: Integer
    field :tag_found, type: Boolean, default: false
    field :ads_count, type: Integer
    field :total_campaigns, type: Integer
    field :shsp_account, type: Boolean, default: false
    field :conversions_count, type: Integer
    field :lifetime_spend, type: Float
    field :acc_created_at, type: Time
    field :newsfeed_campaign_count, type: Integer
    field :budget, type: Float
    field :public_data_campaigns, type: Integer
    field :dynamic_banners, type: Boolean, default: false
    field :trailing_uniques, type: Integer
    field :total_clicks, type: Integer
    field :total_conversions, type: Integer
    field :tracking_mobile, type: Boolean, default: false
    field :mobile_beta, type: Boolean, default: false
    field :profile_access, type: Boolean, default: false
    field :fb_setup, type: Boolean, default: false
    field :created_report, type: Boolean, default: false
    field :has_customer_audience, type: Boolean, default: false
    field :is_invoiced, type: Boolean, default: false
    field :on_click_funnel, type: Boolean, default: false
    field :has_stripe, type: Boolean, default: false
    field :amf_active, type: Boolean, default: false

    index({account_id: 1}, {unique: true})
    index({contact_email: 1}, {unique: true})

    ##
    # Instance Methods
    ##
    def trial_started?
      lifetime_spend >= 1
    end

    def dashboard_url
      "https://app.perfectaudience.com/sites/#{account_id}"
    end

    def to_csv
      CSV.generate { |csv| csv << attributes.values }
    end

    ##
    # Class Methods
    ##
    def self.csv_header
      CSV.generate { |csv| csv << Account.attribute_names }
    end

    def self.field_name(field)
      field.gsub("?", "").gsub(/\s+/, "_").downcase
    end

    def self.load_record(record, verbose=false) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      account_id = record["Account ID"].to_s.strip
      email = record["Contact Email"].to_s.strip.downcase

      unless account_id && !email.blank? && email =~ /^\S+@\S+$/
        warn "Invalid record: #{record}"
        return
      end

      print "Adding #{account_id}... " if verbose

      where(account_id: account_id, contact_email: email).first_or_create do |account|
        record.to_h.each_key do |field|
          next if ["Account ID", "Contact Email"].include? field

          account[Account.field_name(field)] = record[field]
        end

        if account.changed?
          puts "saved" if verbose

          unless account.valid? && account.save!
            warn "Unable to create record for #{email}: #{account.errors.messages.inspect}"
          end
        elsif verbose
          puts "unchanged"
        end
      end
    end

    def self.set_field(field, email_header, file)
      CSV.foreach(file, headers: !email_header.nil?) do |row|
        email = row[email_header || 0].to_s.strip.downcase

        next if email.blank?

        account = Account.where(contact_email: email).first

        unless account
          warn "Account with #{email} could not be found in the MEGA data"
          next
        end

        account.update_attribute(field, true)
      end

      puts "#{Account.where(field => true).count} total records."
    end

    def self.load_mega(file, opts)
      verbose = opts.fetch :verbose, false

      if opts.fetch :prune
        puts "Deleting all records" if verbose
        delete_all
      end

      puts "Adding records..." if verbose

      CSV.foreach(file, headers: true) { |record| load_record(record, verbose) }

      puts "#{Account.count} records added." if verbose
    end

    def self.load_funnel(file)
      set_field(:on_click_funnel, "Email", file)
    end

    def self.load_stripe(file)
      set_field(:has_stripe, "Email", file)
    end

    def self.load_amf(file)
      file_header = File.open(file, &:readline).strip
      set_field(:amf_active, file_header =~ /email/i ? file_header : nil, file)
    end
  end
end
