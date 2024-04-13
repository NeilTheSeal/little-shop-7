class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  enum status: ["Enable", "Disable"]

  def formatted_unit_price
    "$#{(self.unit_price.to_f) / 100}"
  end

  def self.enable_items
    # require 'pry' ; binding.pry
  end
end
