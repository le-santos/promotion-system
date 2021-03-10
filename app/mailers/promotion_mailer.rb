class PromotionMailer < ApplicationMailer
  def notify_approval
    @promotion = Promotion.find(params[:promotion_id])
    return unless @promotion.approved?
    
    mail(subject: "Promoção #{@promotion.name} Aprovada",
         to: @promotion.user.email)
  end
end
