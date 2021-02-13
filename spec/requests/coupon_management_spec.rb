require 'rails_helper'

context 'GET coupon' do
  it 'shuold return coupon details' do
    #Arrange
    user = User.create!(email: 'jose@email.com', password: '123456')
    promotion = Promotion.create!(name: 'Promoloucura', description: 'Descontos insanos',
                                  code: 'LOUCO40', discount_rate: 40,  coupon_quantity: 100, 
                                  expiration_date: '22/12/2030', user: user)
    promotion.generate_coupons!
    coupon = promotion.coupons.last

    #Act
    get api_v1_coupon_path(coupon.code)
    json_response = JSON.parse(response.body, symbolize_names: true)
    
    #Assert
    expect(response).to have_http_status(200)
    expect(json_response[:status]).to eq('active')
    expect(json_response[:promotion][:discount_rate]).to eq(promotion.discount_rate.to_f.to_s)
    expect(json_response[:promotion][:expiration_date]).to eq(promotion.expiration_date.strftime("%F"))
  end

  it 'shuold return 404 if coupon does not exists' do
    get api_v1_coupon_path('id')

    expect(response).to have_http_status(404)
  end
end