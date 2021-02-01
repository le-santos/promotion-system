require 'rails_helper'

feature 'Admin deletes a promotion' do
  scenario 'from a link on details page' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    
    visit root_path
    click_on 'Promoções'
    click_on 'Promoção de Natal'

    expect(page).to have_link('Excluir', href: promotion_path(Promotion.last[:id]))
  end

  scenario 'successfully after confirming exclusion' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    
    visit root_path
    click_on 'Promoções'
    click_on 'Promoção de Natal'
    click_on 'Excluir'

    expect(current_path).to eq(promotions_path)
    expect(Promotion.any?).to eq(false)
    expect(page).to have_content('Nenhuma promoção cadastrada')
  end
end