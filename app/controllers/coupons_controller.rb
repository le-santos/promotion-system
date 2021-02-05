class CouponsController < ApplicationController
  def inactivate 
    @coupon = Coupon.find_by(params[:id])
    @coupon.inactive!
    redirect_to @coupon.promotion
  end
end
