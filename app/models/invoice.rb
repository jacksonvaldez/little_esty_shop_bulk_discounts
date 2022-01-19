class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: [:cancelled, 'in progress', :complete]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_revenue
    money_saved_by_customers = invoice_items.select('max(bulk_discounts.percent_discount) AS percent_discount', 'invoice_items.*')
                 .joins('FULL OUTER JOIN items ON items.id = invoice_items.item_id')
                 .joins('FULL OUTER JOIN bulk_discounts ON items.merchant_id = bulk_discounts.merchant_id')
                 .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
                 .group('invoice_items.id')
                 .sum { |ii| ((ii.unit_price * ii.percent_discount) / 100) * ii.quantity }

    total_revenue - money_saved_by_customers
  end

  def total_revenue_by_merchant(merchant_id)
    invoice_items.joins('INNER JOIN items ON items.id = invoice_items.item_id')
                 .where("items.merchant_id = #{merchant_id}")
                 .sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def discounted_revenue_by_merchant(merchant_id)

    money_saved_by_customer = invoice_items.select('max(bulk_discounts.percent_discount) AS percent_discount', 'invoice_items.*')
                 .joins('FULL OUTER JOIN items ON items.id = invoice_items.item_id')
                 .joins('FULL OUTER JOIN bulk_discounts ON items.merchant_id = bulk_discounts.merchant_id')
                 .where("items.merchant_id = #{merchant_id}")
                 .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
                 .group('invoice_items.id')
                 .sum { |ii| ((ii.unit_price * ii.percent_discount) / 100) * ii.quantity }

    total_revenue_by_merchant(merchant_id) - money_saved_by_customer
  end
end

"SELECT invoice_items.*, bulk_discounts.id AS discount_id FROM invoice_items INNER JOIN items ON items.id = invoice_items.item_id INNER JOIN bulk_discounts ON items.merchant_id = bulk_discounts.merchant_id WHERE invoice_items.invoice_id = 9237 AND (items.merchant_id = 3234) AND (invoice_items.quantity > bulk_discounts.quantity_threshold) GROUP BY invoice_items.id"
