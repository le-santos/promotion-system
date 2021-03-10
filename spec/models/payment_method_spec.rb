require 'rails_helper'

describe PaymentMethod do
  context 'PORO' do
    it 'should initialize a new payment methdod' do
      payment = PaymentMethod.new(name: 'Credit Card' , code: 'CARD')

      expect(payment.name).to eq("Credit Card")
    end
  end

  context 'fetch API data' do
    it 'should get all payment methods' do
      resp_json = File.read(Rails.root.join('spec/support/apis/get_payment_methods.json'))
      resp_double = double('faraday_response', status: 200, body: resp_json )

      allow(Faraday).to receive(:get).with('site.com.br/api/v1/payment_methods')
                                      .and_return(resp_double)

      payment_methods = PaymentMethod.all

      expect(payment_methods.length).to eq 2
      expect(payment_methods.first.name).to eq('Pix')
      expect(payment_methods.last.name).to eq('Boleto')
    end

    it 'should return empty if not authorized' do
      resp_double = double('faraday_response', status: 403, body: '')

      allow(Faraday).to receive(:get).with('site.com.br/api/v1/payment_methods')
                                     .and_return(resp_double)

      payment_methods = PaymentMethod.all

      expect(payment_methods.length).to eq 0
    end
  end
end