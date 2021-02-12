class PromotionsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @promotions = Promotion.all
  end
  
  def show
    @promotion = Promotion.find(params[:id])
  end

  def new
    @promotion = Promotion.new()
    @product_categories = ProductCategory.all
  end

  def create
    @promotion = Promotion.new(promotion_params)
    @promotion.user = current_user

    if @promotion.save
      redirect_to @promotion
    else
      @product_categories = ProductCategory.all
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

  def generate_coupons
    @promotion = Promotion.find(params[:id])
    # metodo extraido para model, como metodo de instancia 
    @promotion.generate_coupons!
    # Usa 'lazy' lookup com i18n e já envia o flash no redirect
    redirect_to promotion_path(@promotion), notice: t('.success')
  end

  def approve
    promotion = Promotion.find(params[:id])
    promotion.approve!(current_user)
    redirect_to promotion
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
            :coupon_quantity,
            product_category_ids: [])
    end

end