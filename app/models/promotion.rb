class Promotion < ApplicationRecord
  has_many :coupons
  has_one :promotion_approval
  has_many :product_category_promotions
  has_many :product_categories, through: :product_category_promotions 

  belongs_to :user
  
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

  def approve!(approval_user)
    PromotionApproval.create(promotion: self, user: approval_user)
  end
  
  def approved?
    promotion_approval
  end

  def approved_at
    promotion_approval&.approved_at
  end

  def approver
    promotion_approval&.user
  end

end