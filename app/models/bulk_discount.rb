class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :quantity_threshold
  validates_presence_of :percent_discount

  validates(:percent_discount, numericality: { less_than_or_equal_to: 100, greater_than_or_equal_to: 0 } )
end
