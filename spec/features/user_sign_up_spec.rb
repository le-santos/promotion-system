require 'rails_helper'

feature 'User sign up' do
  scenario 'sucessfully' do

    visit root_path
    click_on 'Inscrever-se'
    within('form') do
      fill_in 'E-mail', with: 'joao@email.com'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirme sua senha', with: '123456'
      click_on 'Inscrever-se'
    end

    expect(page).to have_content('Bem vindo! Você realizou seu registro com sucesso.')
    expect(page).to have_content('joao@email.com')
  end

  scenario 'is canceled if email not unique' do
    User.create!(email: 'jose@email.com', password: '123456')

    visit root_path
    click_on 'Inscrever-se'
    within('form') do
      fill_in 'E-mail', with: 'jose@email.com'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirme sua senha', with: '123456'
      click_on 'Inscrever-se'
    end

    expect(page).to have_content('Não foi possível salvar usuário: 1 erro')
    expect(page).to have_content('E-mail já está em uso')
    expect(User.all.size).to eq(1)
  end
end