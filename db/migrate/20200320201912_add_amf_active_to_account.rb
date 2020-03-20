class AddAmfActiveToAccount < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :amf_active, :boolean, default: false
  end
end
