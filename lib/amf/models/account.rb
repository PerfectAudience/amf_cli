# frozen_string_literal: true

require "csv"
require "active_record"

module AMF
  class Account < ActiveRecord::Base
    validates :account_id, presence: true
    validates :contact_email, presence: true, uniqueness: {case_insensitive: true}

    def trial_started?
      lifetime_spend >= 0.01
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

    def self.normalize_field(field)
      field.gsub("?", "").gsub(/\s+/, "_").downcase
    end

    def self.load_csv(file, prune=false)
      puts "Loading #{file} into the DB"
      delete_all if prune
      CSV.foreach(file, headers: true) { |record| load record }
    end

    def self.load(record)
      account_id = record["Account ID"].to_s.strip
      email = record["Contact Email"].to_s.strip.downcase
      name = record["Account Name"]

      if account_id && email && email != ~ /@/
        where(account_id: account_id, contact_email: email).first_or_create do |account|
          record.to_h.keys.each do |field|
            next if field == "Account ID" || field == "Contact Email"

            account[Account.normalize_field(field)] = record[field]
          end

          if account.changed? && account.valid?
            account.save
            puts "Loaded #{name} (#{email})"
          end
        end
      end
    end
  end
end
