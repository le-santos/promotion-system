require 'rails_helper'

describe Promotion do

  context 'validation' do
    it 'attributes cannot be blank' do
      promotion = Promotion.new
      
      expect(promotion.valid?).to eq false
      expect(promotion.errors.count).to eq 6
    end

    it 'description is optional' do
      user = User.create!(email: 'jose@email.com', password: '123456')
      promotion = Promotion.new(name: 'Natal', description: '', code: 'NAT',
                                coupon_quantity: 10, discount_rate: 10,
                                expiration_date: '2021-10-10', user: user)

      expect(promotion.valid?).to eq true
    end

    it 'error messages are in portuguese' do
      promotion = Promotion.new

      promotion.valid?

      expect(promotion.errors[:name]).to include('não pode ficar em branco')
      expect(promotion.errors[:code]).to include('não pode ficar em branco')
      expect(promotion.errors[:discount_rate]).to include('não pode ficar em '\
                                                          'branco')
      expect(promotion.errors[:coupon_quantity]).to include('não pode ficar em'\
                                                            ' branco')
      expect(promotion.errors[:expiration_date]).to include('não pode ficar em'\
                                                            ' branco')
      expect(promotion.errors[:user]).to include('é obrigatório(a)')
    end

    it 'code must be uniq' do
      user = User.create!(email: 'jose@email.com', password: '123456')
      Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10,
                        coupon_quantity: 100, expiration_date: '22/12/2033', user: user)
      promotion = Promotion.new(code: 'NATAL10')

      promotion.valid?

      expect(promotion.errors[:code]).to include('já está em uso')
    end
  end

  context '#generate_coupons!' do
    it 'generate coupons from coupon_quantity' do
      user = User.create!(email: 'jose@email.com', password: '123456')
      promotion = Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                                  code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 100, 
                                  expiration_date: '22/12/2030', user: user)

      promotion.generate_coupons!

      expect(promotion.coupons.size).to eq(promotion.coupon_quantity)
      codes = promotion.coupons.pluck(:code) 
      expect(codes).to include('LOUCO40-0001')
      expect(codes).to include('LOUCO40-0100')
      expect(codes).not_to include('LOUCO40-0000')
      expect(codes).not_to include('LOUCO40-0101')
    end

    it 'do not generate if error' do
      user = User.create!(email: 'jose@email.com', password: '123456')
      promotion = Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                                  code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 100, 
                                  expiration_date: '22/12/2030', user: user)

      promotion.coupons.create!(code: 'LOUCO40-0010')

      expect { promotion.generate_coupons! }.to raise_error(ActiveRecord::RecordNotUnique) 

      expect(promotion.coupons.reload.size).to eq(1)
    end

    it 'adds coupons if coupon_quantity increases' do
      user = User.create!(email: 'jose@email.com', password: '123456')
      promotion = Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                                  code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 10, 
                                  expiration_date: '22/12/2030', user: user)
    
      promotion.generate_coupons!
      promotion.coupon_quantity = 15
      promotion.generate_coupons!
      
      expect(promotion.coupons.size).to eq(15)
    end

    it 'removes coupons if coupon_quantity decreases' do
      user = User.create!(email: 'jose@email.com', password: '123456')
      promotion = Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                                  code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 10, 
                                  expiration_date: '22/12/2030', user: user)
    
      promotion.generate_coupons!
      promotion.coupon_quantity = 5
      promotion.generate_coupons!
      
      expect(promotion.coupons.reload.size).to eq(5)
    end
  end

  context '#approve!' do
    describe '' do
      it 'should generate PromotionApproval object' do
        creator = User.create!(email: 'jose@email.com', password: '123456')
        approval_user = User.create!(email: 'pedro@email.com', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                      expiration_date: '22/12/2033', user: creator)

        promotion.approve!(approval_user)

        promotion.reload
        expect(promotion.approved?).to be_truthy
        expect(promotion.approver).to eq(approval_user)
      end

      it 'should not approve if same user object' do
        creator = User.create!(email: 'jose@email.com', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                      expiration_date: '22/12/2033', user: creator)

        promotion.approve!(creator)

        promotion.reload
        expect(promotion.approved?).to be_falsy
      end
    end
  end
end