class DiscountsController < ApplicationController

  def index
    @discounts = BulkDiscount.where(merchant_id: params[:merchant_id])
    @next_holidays = NagerData.new.next_holidays(3)
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show

  end

  def new
    @merchant_id = params[:merchant_id]
  end

  def create
    BulkDiscount.create(
      quantity_threshold: params[:quantity_threshold],
      percent_discount: params[:percent_discount],
      merchant_id: params[:merchant_id]
    )
    redirect_to action: :index
  end

end
