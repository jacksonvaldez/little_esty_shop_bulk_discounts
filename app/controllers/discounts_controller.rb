class DiscountsController < ApplicationController

  def index
    @discounts = BulkDiscount.where(merchant_id: params[:merchant_id])
  end

  def show
    
  end

end
