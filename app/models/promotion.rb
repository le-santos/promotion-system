class Promotion < ApplicationRecord
  has_many :coupons
  
  validates :name, :code, :discount_rate, :coupon_quantity, :expiration_date, presence: true
  validates :code, uniqueness: true

  def generate_coupons!
    Coupon.transaction do
      1.upto(coupon_quantity).each do |number|
        code_num = number.to_s.rjust(4, '0')
        coupons.create!(code: "#{code}-#{code_num}") 
      end
    end
  end
end