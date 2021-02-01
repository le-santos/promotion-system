require 'rails_helper'

feature 'Admin edits a promotion' do
  scenario 'from a link on promotion page' do
    Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                      code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 100, 
                      expiration_date: '22/12/2030')

    visit root_path
    click_on 'Promoções'
    click_on 'Descontos insanos'

    expect(page).to have_link('Editar Promoção', 
                              href: edit_promotion_path(Promotion.find_by!(code: 'LOUCO40')))
  end

  scenario 'successfully' do
    Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                      code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 100, 
                      expiration_date: '22/12/2030')

    visit root_path
    click_on 'Promoções'
    click_on 'Descontos insanos'
    click_on 'Editar Promoção'
    fill_in 'Descrição', with: 'Descontos extremos'
    click_on 'Salvar alterações'

    expect(current_path).to eq(promotion_path(Promotion.find_by!(code: 'LOUCO40')))
    expect(page).to have_content('Descontos extremos')
  end

  scenario 'and attributes cannot be blank' do
    Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                      code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 100, 
                      expiration_date: '22/12/2030')
    
    visit root_path
    click_on 'Promoções'
    click_on 'Descontos insanos'
    click_on 'Editar Promoção'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    fill_in 'Desconto', with: ''
    fill_in 'Quantidade de cupons', with: ''
    fill_in 'Data de término', with: ''
    click_on 'Salvar alterações'

    expect(current_path).to eq(promotion_path(Promotion.find_by!(code: 'LOUCO40')))
    expect(page).to have_content('Não foi possível editar a promoção')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Código não pode ficar em branco')
    expect(page).to have_content('Desconto não pode ficar em branco')
    expect(page).to have_content('Quantidade de cupons não pode ficar em branco')
    expect(page).to have_content('Data de término não pode ficar em branco')
  end

  scenario 'and code must be unique' do
    Promotion.create!(name: 'SuperPromo', description: 'Descontos imensos',
                      code: 'SUPERPRO', discount_rate: 40,  coupon_quantity: 100, 
                      expiration_date: '22/12/2030')
    Promotion.create!(name: 'Descontaço', description: 'Que desconto!',
                      code: 'BIGPROMO', discount_rate: 40,  coupon_quantity: 100, 
                      expiration_date: '22/12/2030')

    visit root_path
    click_on 'Promoções'
    click_on 'Que desconto!'
    click_on 'Editar Promoção'
    fill_in 'Código', with: 'SUPERPRO'
    click_on 'Salvar alterações'
    
    expect(current_path).to eq(promotion_path(Promotion.find_by!(code: 'BIGPROMO')))
    expect(page).to have_content('Não foi possível editar a promoção')
    expect(page).to have_content('Código já está em uso')
  end

  scenario 'and cancel edit' do
    Promotion.create!(name: 'Descontaço', description: 'Que desconto!',
                      code: 'BIGPROMO', discount_rate: 40,  coupon_quantity: 100, 
                      expiration_date: '22/12/2030')

    visit root_path
    click_on 'Promoções'
    click_on 'Que desconto!'
    click_on 'Editar Promoção'
    fill_in 'Nome', with: 'Big Promoção'
    click_on 'Cancelar edição'
    
    expect(current_path).to eq(promotion_path(Promotion.find_by!(code: 'BIGPROMO')))
    expect(page).to have_content('Descontaço')
  end
end