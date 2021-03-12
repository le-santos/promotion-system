class Coupon < ApplicationRecord
  belongs_to :promotion

  enum status: { active: 0, canceled: 1, inactive: 10 }

  def cancel_coupon!
    self.canceled!
  end
end
