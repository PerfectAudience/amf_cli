class AddHasStripeToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :has_stripe, :boolean, default: false
  end
end
