require 'rails_helper'


RSpec.describe 'Merchant Discounts index page' do
  before(:each) do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    @bulk_discount_1 = BulkDiscount.create!(quantity_threshold: 10, percent_discount: 20, merchant_id: @merchant1.id )
    @bulk_discount_2 = BulkDiscount.create!(quantity_threshold: 15, percent_discount: 25, merchant_id: @merchant1.id )
    @bulk_discount_3 = BulkDiscount.create!(quantity_threshold: 20, percent_discount: 30, merchant_id: @merchant1.id )

    stub_request(:get, "https://date.nager.at/api/v3/NextPublicHolidays/US").
         to_return(status: 200, body: "[{\"date\":\"2022-01-17\",\"localName\":\"Martin Luther King, Jr. Day\",\"name\":\"Martin Luther King, Jr. Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-02-21\",\"localName\":\"Presidents Day\",\"name\":\"Washington's Birthday\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-04-15\",\"localName\":\"Good Friday\",\"name\":\"Good Friday\",\"countryCode\":\"US\",\"fixed\":false,\"global\":false,\"counties\":[\"US-CT\",\"US-DE\",\"US-HI\",\"US-IN\",\"US-KY\",\"US-LA\",\"US-NC\",\"US-ND\",\"US-NJ\",\"US-TN\"],\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-05-30\",\"localName\":\"Memorial Day\",\"name\":\"Memorial Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-06-20\",\"localName\":\"Juneteenth\",\"name\":\"Juneteenth\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":2021,\"types\":[\"Public\"]},{\"date\":\"2022-07-04\",\"localName\":\"Independence Day\",\"name\":\"Independence Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-09-05\",\"localName\":\"Labor Day\",\"name\":\"Labour Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-10-10\",\"localName\":\"Columbus Day\",\"name\":\"Columbus Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":false,\"counties\":[\"US-AL\",\"US-AZ\",\"US-CO\",\"US-CT\",\"US-DC\",\"US-GA\",\"US-ID\",\"US-IL\",\"US-IN\",\"US-IA\",\"US-KS\",\"US-KY\",\"US-LA\",\"US-ME\",\"US-MD\",\"US-MA\",\"US-MS\",\"US-MO\",\"US-MT\",\"US-NE\",\"US-NH\",\"US-NJ\",\"US-NM\",\"US-NY\",\"US-NC\",\"US-OH\",\"US-OK\",\"US-PA\",\"US-RI\",\"US-SC\",\"US-TN\",\"US-UT\",\"US-VA\",\"US-WV\"],\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-11-11\",\"localName\":\"Veterans Day\",\"name\":\"Veterans Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-11-24\",\"localName\":\"Thanksgiving Day\",\"name\":\"Thanksgiving Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":1863,\"types\":[\"Public\"]},{\"date\":\"2022-12-26\",\"localName\":\"Christmas Day\",\"name\":\"Christmas Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2023-01-02\",\"localName\":\"New Year's Day\",\"name\":\"New Year's Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]}]", headers: {})

    visit "/merchant/#{@merchant1.id}/discounts"
  end

  it 'lists each discount and their attributes' do
    expect(page).to have_content("##{@bulk_discount_1.id} - 10 items, 20% off")
    expect(page).to have_content("##{@bulk_discount_2.id} - 15 items, 25% off")
    expect(page).to have_content("##{@bulk_discount_3.id} - 20 items, 30% off")
  end

  it 'each listed bulk discount contains a link to its show page' do
    within "#discount-#{@bulk_discount_1.id}" do
      expect(page).to have_link("View")
    end
  end

  it 'the link to view each discount takes you to correct path' do
    within "#discount-#{@bulk_discount_2.id}" do
      click_link("View")
    end

    expect(current_path).to eq("/merchant/#{@merchant1.id}/discounts/#{@bulk_discount_2.id}")
  end

  it 'When you click the Create Discount link, it takes you to correct path' do
    click_link("Create Discount")

    expect(current_path).to eq("/merchant/#{@merchant1.id}/discounts/new")
  end

  it 'When you click the delete link next to each discount, it deletes it' do
    within "#discount-#{@bulk_discount_2.id}" do
      click_link("Delete")
    end

    expect(current_path).to eq("/merchant/#{@merchant1.id}/discounts")
    expect(page).to_not have_content("##{@bulk_discount_2.id} - 15 items, 25% off")
  end

  it 'takes you to correct path when you click the edit link next to a discount' do
    within "#discount-#{@bulk_discount_2.id}" do
      click_link("Edit")
    end

    expect(current_path).to eq("/merchant/#{@merchant1.id}/discounts/#{@bulk_discount_2.id}/edit")
  end

  it 'it displays the name and date of the next 3 upcoming US holidays' do
    holiday_data = NagerData.new.next_holidays(3)

    expect(page).to have_content(holiday_data[0][:name])
    expect(page).to have_content(holiday_data[0][:date])
    expect(page).to have_content(holiday_data[1][:name])
    expect(page).to have_content(holiday_data[1][:date])
    expect(page).to have_content(holiday_data[2][:name])
    expect(page).to have_content(holiday_data[2][:date])
  end

end
