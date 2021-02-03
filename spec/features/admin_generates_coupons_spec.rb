require 'rails_helper'

feature 'Admin generates coupons' do
  scenario 'of a promotion' do
    promotion = Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                      code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 100, 
                      expiration_date: '22/12/2030')
    
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Gerar Cupons'

    expect(current_path).to eq(promotion_path(promotion))
    expect(page).to have_content('Cupons gerados com sucesso')
    expect(page).to have_content('LOUCO40-0001')
    expect(page).to have_content('LOUCO40-0002')
    expect(page).to have_content('LOUCO40-0100')
    expect(page).not_to have_content('LOUCO40-0101')
  end
end