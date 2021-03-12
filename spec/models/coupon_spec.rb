require 'rails_helper'

RSpec.describe Coupon, type: :model do
  context 'cancel coupons' do
    it 'should cancel if promotion expired' do
      user = User.create!(email: 'jose@email.com', password: '123456')
      promotion = Promotion.create!(name: 'Natal', description: '', code: 'NAT',
                                coupon_quantity: 10, discount_rate: 10,
                                expiration_date: '2021-10-10', user: user)
      promotion.generate_coupons!
      coupon = promotion.coupons[1]
      promotion.update(expiration_date: 5.day.ago)

      promotion.reload
      coupon.reload
      
      expect(coupon.canceled?).to be_truthy 
    end
  end
end
