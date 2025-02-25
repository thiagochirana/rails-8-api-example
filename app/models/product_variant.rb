class ProductVariant < ApplicationRecord
  belongs_to :product
  has_one :stock_transaction
end
