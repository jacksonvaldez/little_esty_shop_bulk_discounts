require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end
  describe "instance methods" do
    it "total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Dog Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @item_9 = Item.create!(name: "Dog Shampoo", description: "washes dog", unit_price: 5, merchant_id: @merchant2.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @customer_2 = Customer.create!(first_name: 'John', last_name: 'Wick')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @invoice_2 = Invoice.create!(customer_id: @customer_2.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 15, unit_price: 10, status: 1)
      @ii_12 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 40, unit_price: 10, status: 1)
      @ii_13 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 3, unit_price: 10, status: 1)
      @ii_14 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_9.id, quantity: 69, unit_price: 10, status: 1)
      @ii_15 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 30, unit_price: 10, status: 1)

      @bulk_discount_1 = BulkDiscount.create!(quantity_threshold: 10, percent_discount: 20, merchant_id: @merchant1.id )
      @bulk_discount_2 = BulkDiscount.create!(quantity_threshold: 15, percent_discount: 25, merchant_id: @merchant1.id )
      @bulk_discount_3 = BulkDiscount.create!(quantity_threshold: 20, percent_discount: 30, merchant_id: @merchant1.id )

      expect(@invoice_1.total_revenue).to eq(1360.0)
      expect(@invoice_1.discounted_revenue).to eq(1202.5)
    end
  end



  describe '#total_revenue_by_merchant and #discounted_revenue_by_merchant' do
    it 'returns the correct discounted revenue for a invoice' do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Dog Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @item_9 = Item.create!(name: "Dog Shampoo", description: "washes dog", unit_price: 5, merchant_id: @merchant2.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @customer_2 = Customer.create!(first_name: 'John', last_name: 'Wick')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @invoice_2 = Invoice.create!(customer_id: @customer_2.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 15, unit_price: 10, status: 1)
      @ii_12 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 40, unit_price: 10, status: 1)
      @ii_13 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 3, unit_price: 10, status: 1)
      @ii_14 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_9.id, quantity: 69, unit_price: 10, status: 1)
      @ii_15 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 30, unit_price: 10, status: 1)

      @bulk_discount_1 = BulkDiscount.create!(quantity_threshold: 10, percent_discount: 20, merchant_id: @merchant1.id )
      @bulk_discount_2 = BulkDiscount.create!(quantity_threshold: 15, percent_discount: 25, merchant_id: @merchant1.id )
      @bulk_discount_3 = BulkDiscount.create!(quantity_threshold: 20, percent_discount: 30, merchant_id: @merchant1.id )

      expect(@invoice_1.total_revenue_by_merchant(@merchant1.id)).to eq(670)
      expect(@invoice_1.discounted_revenue_by_merchant(@merchant1.id)).to eq(512.5)
      expect(@invoice_1.total_revenue_by_merchant(@merchant2.id)).to eq(690)
      expect(@invoice_1.discounted_revenue_by_merchant(@merchant2.id)).to eq(690)
    end
  end
end
