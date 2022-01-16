require 'rails_helper'

RSpec.describe 'Edit Form for discount' do
  before(:each) do
    @merchant = Merchant.create!(name: 'Hair Care')

    @discount = BulkDiscount.create!(quantity_threshold: 10, percent_discount: 20, merchant_id: @merchant.id )

    visit "/merchant/#{@merchant.id}/discounts/#{@discount.id}/edit"
  end

  it 'updates the discount when form is submitted' do
    fill_in(:quantity_threshold, with: '55')
    fill_in(:percent_discount, with: '44')
    click_button("Save Changes")

    expect(current_path).to eq("/merchant/#{@merchant.id}/discounts/#{@discount.id}")
    expect(page).to have_content("Bulk Discount ##{@discount.id}")
    expect(page).to have_content("55 items, 44% off")
  end

  it 'doesnt do anything if you click save changes without changes the fields' do
    click_button("Save Changes")

    expect(current_path).to eq("/merchant/#{@merchant.id}/discounts/#{@discount.id}")
    expect(page).to have_content("Bulk Discount ##{@discount.id}")
    expect(page).to have_content("10 items, 20% off")
  end
end
