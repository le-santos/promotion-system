class PaymentMethod #PORO -> plain old ruby obj
  attr_reader :name, :code
  
  def self.all
    response = Faraday.get('site.com.br/api/v1/payment_methods')
    return [] if response.status == 403

    json_response = JSON.parse(response.body, symbolize_names: true)
    
    payment_methods = []
    json_response.each do |r|
      payment_methods << PaymentMethod.new(name: r[:name], code: r[:code])
    end
    return payment_methods
  end

  def initialize(name:, code:)
    @name = name
    @code = code
  end
end