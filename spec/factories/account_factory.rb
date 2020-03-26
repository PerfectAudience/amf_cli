# frozen_string_literal: true

module AMF
  FactoryBot.define do
    factory :account, class: AMF::Account do
      account_id { SecureRandom.hex(10) }
      account_name { "Test Account" }
      account_contact { "John Doe" }
      contact_email { "#{account_id}@example.org" }
    end
  end
end
