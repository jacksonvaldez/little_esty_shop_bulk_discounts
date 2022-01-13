require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  it { should belong_to(:merchant) }

  it { should validate_presence_of(:quantity_threshold)}
  it { should validate_presence_of(:percent_discount)}
end
