require 'rails_helper'

feature 'Admin edits a promotion' do
  scenario 'successfully' do
    #Arrange
    Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                      code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 100, 
                      expiration_date: '22/12/2030')

    #Act
    visit root_path
    click_on 'Promoções'
    click_on 'Descontos insanos'
    click_on 'Editar Promoção'
    fill_in 'Descrição', with: 'Descontos extremos'
    click_on 'Salvar alterações'

    #Assert
    expect(current_path).to eq(promotion_path(Promotion.last))
    expect(page).to have_content('Descontos extremos')
  end
  

end