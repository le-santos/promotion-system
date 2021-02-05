class Promotion < ApplicationRecord
  has_many :coupons
  
  validates :name, :code, :discount_rate, :coupon_quantity, :expiration_date, presence: true
  validates :code, uniqueness: true

  def generate_coupons!
    Coupon.transaction do
      coupon_quantity >= coupons.size ? add_coupons : remove_coupons
    end
  end

  def add_coupons
    starting_coupon = coupons.size + 1
    starting_coupon.upto(coupon_quantity).each do |number|
      code_num = number.to_s.rjust(4, '0')
      coupons.create!(code: "#{code}-#{code_num}") 
    end
  end

  def remove_coupons
    remove_amount = coupons.size - coupon_quantity
    coupons.last(remove_amount).each(&:destroy)
  end
end