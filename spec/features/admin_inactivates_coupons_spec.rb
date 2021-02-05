require 'rails_helper'

feature 'admin inactivates a coupon' do
  scenario 'successfully' do
    promotion = Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                                  code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 1, 
                                  expiration_date: '22/12/2030')
    promotion.generate_coupons!

    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Desativar'

    expect(page).to have_content('LOUCO40-0001 (Inativo)')

    #TODO expect(promotion.coupons.reload.available.size).to eq(0)
    #TODO expect(coupon.status).to eq(:inactive)
  end

  scenario 'and updates available coupons' do
    promotion = Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                                  code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 5, 
                                  expiration_date: '22/12/2030')
    promotion.generate_coupons!

    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    find_link('Desativar', match: :first).click

    expect(promotion.coupons.where( status: 'active').size).to eq(4) 
    expect(page).to have_content('4 cupons')
  end
end