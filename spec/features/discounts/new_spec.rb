require 'rails_helper'

RSpec.describe 'New Discount Form' do
  before(:each) do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @bulk_discount_1 = BulkDiscount.create!(quantity_threshold: 10, percent_discount: 20, merchant_id: @merchant1.id )
    @bulk_discount_2 = BulkDiscount.create!(quantity_threshold: 15, percent_discount: 25, merchant_id: @merchant1.id )
    @bulk_discount_3 = BulkDiscount.create!(quantity_threshold: 20, percent_discount: 30, merchant_id: @merchant1.id )

    stub_request(:get, "https://date.nager.at/api/v3/NextPublicHolidays/US").
         to_return(status: 200, body: "[{\"date\":\"2022-01-17\",\"localName\":\"Martin Luther King, Jr. Day\",\"name\":\"Martin Luther King, Jr. Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-02-21\",\"localName\":\"Presidents Day\",\"name\":\"Washington's Birthday\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-04-15\",\"localName\":\"Good Friday\",\"name\":\"Good Friday\",\"countryCode\":\"US\",\"fixed\":false,\"global\":false,\"counties\":[\"US-CT\",\"US-DE\",\"US-HI\",\"US-IN\",\"US-KY\",\"US-LA\",\"US-NC\",\"US-ND\",\"US-NJ\",\"US-TN\"],\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-05-30\",\"localName\":\"Memorial Day\",\"name\":\"Memorial Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-06-20\",\"localName\":\"Juneteenth\",\"name\":\"Juneteenth\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":2021,\"types\":[\"Public\"]},{\"date\":\"2022-07-04\",\"localName\":\"Independence Day\",\"name\":\"Independence Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-09-05\",\"localName\":\"Labor Day\",\"name\":\"Labour Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-10-10\",\"localName\":\"Columbus Day\",\"name\":\"Columbus Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":false,\"counties\":[\"US-AL\",\"US-AZ\",\"US-CO\",\"US-CT\",\"US-DC\",\"US-GA\",\"US-ID\",\"US-IL\",\"US-IN\",\"US-IA\",\"US-KS\",\"US-KY\",\"US-LA\",\"US-ME\",\"US-MD\",\"US-MA\",\"US-MS\",\"US-MO\",\"US-MT\",\"US-NE\",\"US-NH\",\"US-NJ\",\"US-NM\",\"US-NY\",\"US-NC\",\"US-OH\",\"US-OK\",\"US-PA\",\"US-RI\",\"US-SC\",\"US-TN\",\"US-UT\",\"US-VA\",\"US-WV\"],\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-11-11\",\"localName\":\"Veterans Day\",\"name\":\"Veterans Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-11-24\",\"localName\":\"Thanksgiving Day\",\"name\":\"Thanksgiving Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":1863,\"types\":[\"Public\"]},{\"date\":\"2022-12-26\",\"localName\":\"Christmas Day\",\"name\":\"Christmas Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2023-01-02\",\"localName\":\"New Year's Day\",\"name\":\"New Year's Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]}]", headers: {})

    visit "/merchant/#{@merchant1.id}/discounts/new"
  end

  it 'displays inputs to create a new discount' do
    expect(page).to have_field(:quantity_threshold)
    expect(page).to have_field(:percent_discount)
    expect(page).to have_button("Add Discount")
  end

  it 'adds the discount once the form is submitted' do
    fill_in(:quantity_threshold, with: '40')
    fill_in(:percent_discount, with: '10')
    click_button("Add Discount")

    expect(current_path).to eq("/merchant/#{@merchant1.id}/discounts")
    expect(page).to have_content("40 items, 10% off")
  end
end
