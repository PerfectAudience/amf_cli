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

    def self.load_mega(file, prune=false)
      if prune
        puts "Deleting all records"
        delete_all
      end

      puts "Loading #{file} into the DB"
      CSV.foreach(file, headers: true) { |record| load record }

      puts "#{Account.count} records added."
    end

    def self.load_stripe(file)
      CSV.foreach(file, headers: true) do |row|
        email = row["Email"].to_s.strip.downcase

        account = Account.where(contact_email: email).first unless email.empty?

        unless account
          warn "Account with #{email} could not be found in the MEGA data"
          next
        end

        account.update has_stripe: true
      end

      puts "#{Account.where(has_stripe: true).count} records added."
    end

    def self.load_amf(file)
      CSV.foreach(file, headers: true) do |row|
        email = row["contact_email"].to_s.strip.downcase

        account = Account.where(contact_email: email).first unless email.empty?

        unless account
          warn "Account with #{email} could not be found in the MEGA data"
          next
        end

        account.update amf_active: true
      end

      puts "#{Account.where(amf_active: true).count} records added."
    end

    def self.load(record)
      account_id = record["Account ID"].to_s.strip
      email = record["Contact Email"].to_s.strip.downcase
      name = record["Account Name"]

      if account_id && email && email =~ /^\S+@\S+$/
        where(account_id: account_id, contact_email: email).first_or_create do |account|
          record.to_h.keys.each do |field|
            next if field == "Account ID" || field == "Contact Email"

            account[Account.normalize_field(field)] = record[field]
          end

          if account.changed?
            unless account.valid? && account.save
              warn "Unable to create record for #{email}: #{account.errors.messages.inspect}"
            end
          end
        end
      end
    end
  end
end
