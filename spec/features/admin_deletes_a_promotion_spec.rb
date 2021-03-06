require 'rails_helper'

feature 'Admin deletes a promotion' do
  # select driver for this test only  
  background do
    Capybara.current_driver = :selenium_chrome_headless
  end

  # Marca o teste como :js ativo, para ativar o selenium
  scenario 'from a link on details page', :js do
    user = User.create!(email: 'jose@email.com', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    login_as user, scope: :user    
    visit root_path
    click_on 'Promoções'
    click_on promotion.name

    expect(page).to have_link('Excluir', href: promotion_path(promotion))
  end

  scenario 'successfully after confirming exclusion' do
    user = User.create!(email: 'jose@email.com', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    
    login_as user, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    
    accept_confirm do
      click_link 'Excluir'
    end

    expect(current_path).to eq(promotions_path)
    expect(Promotion.any?).to eq(false)
    expect(page).to have_content('Nenhuma promoção cadastrada')
  end

  scenario 'and can abort the exclusion' do
    user = User.create!(email: 'jose@email.com', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    
    login_as user, scope: :user
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_link 'Excluir'
    page.driver.browser.switch_to.alert.dismiss

    expect(current_path).to eq(promotion_path(promotion))
    expect(Promotion.any?).to eq(true)
    expect(page).to have_content('Promoção de Natal')
  end
end