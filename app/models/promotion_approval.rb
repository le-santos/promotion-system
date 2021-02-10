class PromotionApproval < ApplicationRecord
  belongs_to :promotion
  belongs_to :user

  validate :differente_user

  private
  
  def differente_user
    if promotion && promotion.user == user #curto circuito
      errors.add(:user, 'não pode ser o criador da promoção')
    end
  end
end
