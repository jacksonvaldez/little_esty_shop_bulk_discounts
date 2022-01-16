class DiscountsController < ApplicationController

  def index
    @discounts = BulkDiscount.where(merchant_id: params[:merchant_id])
    @next_holidays = NagerData.new.next_holidays(3)
  end

  def show

  end

end
