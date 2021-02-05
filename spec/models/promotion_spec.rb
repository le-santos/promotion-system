require 'rails_helper'

describe Promotion do

  context 'validation' do
    it 'attributes cannot be blank' do
      promotion = Promotion.new

      expect(promotion.valid?).to eq false
      expect(promotion.errors.count).to eq 5
    end

    it 'description is optional' do
      promotion = Promotion.new(name: 'Natal', description: '', code: 'NAT',
                                coupon_quantity: 10, discount_rate: 10,
                                expiration_date: '2021-10-10')

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
    end

    it 'code must be uniq' do
      Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10,
                        coupon_quantity: 100, expiration_date: '22/12/2033')
      promotion = Promotion.new(code: 'NATAL10')

      promotion.valid?

      expect(promotion.errors[:code]).to include('já está em uso')
    end
  end

  context '#generate_coupons!' do
    it 'generate coupons from coupon_quantity' do
      promotion = Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                                  code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 100, 
                                  expiration_date: '22/12/2030')

      promotion.generate_coupons!

      expect(promotion.coupons.size).to eq(promotion.coupon_quantity)
      codes = promotion.coupons.pluck(:code) 
      expect(codes).to include('LOUCO40-0001')
      expect(codes).to include('LOUCO40-0100')
      expect(codes).not_to include('LOUCO40-0000')
      expect(codes).not_to include('LOUCO40-0101')
    end

    it 'do not generate if error' do
      promotion = Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                                  code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 100, 
                                  expiration_date: '22/12/2030')

      promotion.coupons.create!(code: 'LOUCO40-0010')

      expect { promotion.generate_coupons! }.to raise_error(ActiveRecord::RecordNotUnique) 

      expect(promotion.coupons.reload.size).to eq(1)
    end

    it 'adds coupons if coupon_quantity increases' do
      promotion = Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                                  code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 10, 
                                  expiration_date: '22/12/2030')
    
      promotion.generate_coupons!
      promotion.coupon_quantity = 15
      promotion.generate_coupons!
      
      expect(promotion.coupons.size).to eq(15)
    end

    it 'removes coupons if coupon_quantity decreases' do
      promotion = Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                                  code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 10, 
                                  expiration_date: '22/12/2030')
    
      promotion.generate_coupons!
      promotion.coupon_quantity = 5
      promotion.generate_coupons!
      
      expect(promotion.coupons.reload.size).to eq(5)
    end
  end

end