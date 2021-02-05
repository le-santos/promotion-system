class AddStatusToCoupons < ActiveRecord::Migration[6.1]
  def change
    add_column :coupons, :status, :integer, default: 0, null: false
  end
end
