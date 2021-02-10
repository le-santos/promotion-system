require 'rails_helper'

RSpec.describe PromotionApproval, type: :model do
  describe 'valid?' do
    describe 'different user' do
      it 'is differente' do
        creator = User.create!(email: 'jose@email.com', password: '123456')
        approval_user = User.create!(email: 'pedro@email.com', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                              code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                              expiration_date: '22/12/2033', user: creator)

        approval = PromotionApproval.new(promotion: promotion, user: approval_user)
        result = approval.valid?

        expect(result).to eq(true)
      end

      it 'is the same' do
        creator = User.create!(email: 'jose@email.com', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                              code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                              expiration_date: '22/12/2033', user: creator)

        approval = PromotionApproval.new(promotion: promotion, user: creator)
        result = approval.valid?

        expect(result).to eq(false)
      end

      it 'has no promotion or user' do
        approval = PromotionApproval.new()

        result = approval.valid?

        expect(result).to eq false
      end
    end
  end
end
