class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  enum :status, %w[pending packaged shipped]
end
