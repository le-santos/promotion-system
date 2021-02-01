class PromotionsController < ApplicationController
  def index
    @promotions = Promotion.all
  end
  
  def show
    @promotion = Promotion.find(params[:id])
  end

  def new
    @promotion = Promotion.new()
  end

  def create
    @promotion = Promotion.new(promotion_params)

    if @promotion.save
      redirect_to @promotion
    else
      render :new
    end
  end

  def edit
    @promotion = Promotion.find(params[:id])
  end

  def update
    @promotion = Promotion.find(params[:id])

    if @promotion.update(promotion_params)
      redirect_to @promotion
    else
      render :edit
    end
  end

  def destroy
    @promotion = Promotion.find(params[:id])
    @promotion.destroy

    redirect_to promotions_path
  end

  private
    def promotion_params
      params
        .require(:promotion)
        .permit(
            :name, 
            :description, 
            :discount_rate, 
            :code, 
            :expiration_date, 
            :coupon_quantity)
    end

end