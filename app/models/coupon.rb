class Coupon < ApplicationRecord
  belongs_to :promotion

  enum status: { active: 0 , inactive: 10 }
end
