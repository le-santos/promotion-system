class AddStatusToPromotion < ActiveRecord::Migration[6.1]
  def change
    add_column :promotions, :status, :integer, default: 0
  end
end
