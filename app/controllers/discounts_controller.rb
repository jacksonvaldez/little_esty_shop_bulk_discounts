class DiscountsController < ApplicationController

  def index
    @discounts = BulkDiscount.where(merchant_id: params[:merchant_id])
    @next_holidays = NagerData.new.next_holidays(3)
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show

  end

  def new
    @discount = BulkDiscount.new
  end

end
