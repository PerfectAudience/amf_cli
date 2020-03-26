# frozen_string_literal: true

require "tempfile"

module AMF
  RSpec.describe Account, type: :model do
    let(:account) { create :account }

    it { is_expected.to be_mongoid_document }

    context "indexes" do
      it { is_expected.to have_index_for(account_id: 1).with_options({unique: true}) }
      it { is_expected.to have_index_for(contact_email: 1).with_options({unique: true}) }
    end

    context "validations" do
      it { is_expected.to validate_presence_of(:account_id) }
      it { is_expected.to validate_uniqueness_of(:account_id) }
      it { is_expected.to validate_presence_of(:contact_email) }
      it { is_expected.to validate_uniqueness_of(:contact_email) }
    end

    describe "Class Methods" do
      let(:attributes) { Account.attribute_names - %w[_id] }

      context "csv_attributes" do
        subject { Account.csv_attributes }

        it { is_expected.not_to include %w[_id] }
        it { is_expected.to eq attributes }
      end

      context "csv_header" do
        subject { Account.csv_header }

        it { is_expected.to eq attributes.join(",") + "\n" }
      end

      context "field_name()" do
        it "is expected to return a valid field name" do
          expect(Account.field_name("TestField")).to eq :test_field
          expect(Account.field_name("Test Field")).to eq :test_field
          expect(Account.field_name("Test_Field")).to eq :test_field
          expect(Account.field_name("Test-Field")).to eq :test_field
          expect(Account.field_name("is_boolean?")).to eq :is_boolean
        end
      end

      context "load_amf_record" do
      end

      context "set_field" do
        let(:file) { Tempfile.new("amf_test") }

        # Sanity Test
        before(:each) { account.update amf_active: false }

        context "when provided a header" do
          it "sets the given field true" do
            file.write("Email\n")
            file.write(account.contact_email + "\n")
            file.close

            Account.set_field(:amf_active, "Email", file.path)
            expect(account.reload.amf_active).to be true
          ensure
            file.unlink
          end
        end

        context "when header is nil" do
          it "sets the given field true" do
            file.write(account.contact_email + "\n")
            file.close

            Account.set_field(:amf_active, nil, file.path)
            expect(account.reload.amf_active).to be true
          ensure
            file.unlink
          end
        end
      end
    end

    describe "Instance Methods" do
      context "#trial_started?" do
        subject { account.trial_started? }

        context "when lifetime_spend > limit" do
          before { account.lifetime_spend = 5.0 }

          it { is_expected.to be_truthy }
        end

        context "when lifetime_spend < limit" do
          before { account.lifetime_spend = 0.1 }

          it { is_expected.not_to be_truthy }
        end
      end

      context "#dashboard_url" do
        subject { account.dashboard_url }

        it { is_expected.to eq "https://app.perfectaudience.com/sites/#{account.account_id}" }
      end

      context "#to_csv" do
        subject { account.to_csv }

        it {
          is_expected.to match(
            /^#{account.account_id},#{account.account_name},#{account.account_contact},#{account.contact_email}/
          )
        }
      end
    end
  end
end
