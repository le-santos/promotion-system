require 'rails_helper'

feature 'admin inactivates a coupon' do
  scenario 'successfully' do
    promotion = Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                                  code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 1, 
                                  expiration_date: '22/12/2030')
    coupon = Coupon.create!(code: 'LOUCO40-0001', promotion: promotion, status: :active)

    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Desativar'

    coupon.reload
    expect(page).to have_content('LOUCO40-0001 (Inativo)')
    expect(coupon).to be_inactive
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

  scenario 'and hides inactivate button' do
    promotion = Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                                  code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 5, 
                                  expiration_date: '22/12/2030')
    active_coupon = Coupon.create!(code: 'LOK0002', promotion: promotion, status: :active)
    inactive_coupon = Coupon.create!(code: 'LOK0001', promotion: promotion, status: :inactive)
                            
    visit root_path
    click_on 'Promoções'
    click_on promotion.name

    within("div#coupon-#{active_coupon.id}") do
      expect(page).to have_link('Desativar')
    end

    within("div#coupon-#{inactive_coupon.id}") do
      expect(page).not_to have_link('Desativar')
    end
  end
end