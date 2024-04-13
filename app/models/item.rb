class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  enum status: %w[enabled disabled]

  def formatted_unit_price
    "$#{unit_price.to_f / 100}"
  end
end
