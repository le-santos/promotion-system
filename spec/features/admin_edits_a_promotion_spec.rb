require 'rails_helper'

feature 'Admin edits a promotion' do
  scenario 'from a link on promotion page' do
    user = User.create!(email: 'jose@email.com', password: '123456')
    promotion = Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                      code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 100, 
                      expiration_date: '22/12/2030', user: user)

    login_as user, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on promotion.name

    expect(page).to have_link('Editar Promoção', 
                              href: edit_promotion_path(promotion))
  end

  scenario 'successfully' do
    user = User.create!(email: 'jose@email.com', password: '123456')
    promotion = Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                      code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 100, 
                      expiration_date: '22/12/2030', user: user)

    login_as user, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Editar Promoção'
    fill_in 'Descrição', with: 'Descontos extremos'
    click_on 'Salvar alterações'
    #check 'Smartphones'


    expect(current_path).to eq(promotion_path(promotion))
    expect(page).to have_content('Descontos extremos')
  end

  scenario 'and attributes cannot be blank' do
    user = User.create!(email: 'jose@email.com', password: '123456')
    promotion = Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                      code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 100, 
                      expiration_date: '22/12/2030', user: user)
    ProductCategory.create!(name: 'Smartphones', code: 'SMARTPH')
    ProductCategory.create!(name: 'Jogos', code: 'GAME')
    
    login_as user, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Editar Promoção'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    fill_in 'Desconto', with: ''
    fill_in 'Quantidade de cupons', with: ''
    fill_in 'Data de término', with: ''
    click_on 'Salvar alterações'

    expect(current_path).to eq(promotion_path(promotion))
    expect(page).to have_content('Não foi possível editar a promoção')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Código não pode ficar em branco')
    expect(page).to have_content('Desconto não pode ficar em branco')
    expect(page).to have_content('Quantidade de cupons não pode ficar em branco')
    expect(page).to have_content('Data de término não pode ficar em branco')
  end

  scenario 'and code must be unique' do
    user = User.create!(email: 'jose@email.com', password: '123456')
    Promotion.create!(name: 'SuperPromo', description: 'Descontos imensos',
                      code: 'SUPERPRO', discount_rate: 40,  coupon_quantity: 100, 
                      expiration_date: '22/12/2030', user: user)
    promotion = Promotion.create!(name: 'Descontaço', description: 'Que desconto!',
                      code: 'BIGPROMO', discount_rate: 40,  coupon_quantity: 100, 
                      expiration_date: '22/12/2030', user: user)

    login_as user, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Editar Promoção'
    fill_in 'Código', with: 'SUPERPRO'
    click_on 'Salvar alterações'
    
    expect(current_path).to eq(promotion_path(promotion))
    expect(page).to have_content('Não foi possível editar a promoção')
    expect(page).to have_content('Código já está em uso')
  end

  scenario 'and cancel edit' do
    user = User.create!(email: 'jose@email.com', password: '123456')
    promotion = Promotion.create!(name: 'Descontaço', description: 'Que desconto!',
                      code: 'BIGPROMO', discount_rate: 40,  coupon_quantity: 100, 
                      expiration_date: '22/12/2030', user: user)

    login_as user, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Editar Promoção'
    fill_in 'Nome', with: 'Big Promoção'
    click_on 'Cancelar edição'
    
    expect(current_path).to eq(promotion_path(promotion))
    expect(page).to have_content('Descontaço')
  end
end