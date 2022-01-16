require 'rails_helper'

RSpec.describe 'Discount Show Page' do
  before(:each) do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @bulk_discount_1 = BulkDiscount.create!(quantity_threshold: 10, percent_discount: 20, merchant_id: @merchant1.id )

    visit "/merchant/#{@merchant1.id}/discounts/#{@bulk_discount_1.id}"
  end

  it 'displays the discounts attributes' do
    expect(page).to have_content("Bulk Discount ##{@bulk_discount_1.id}")
    expect(page).to have_content("10 items, 20% off")
  end
end
