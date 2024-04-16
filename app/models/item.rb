class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  enum status: ["enabled", "disabled"]

  def formatted_unit_price
    "$#{unit_price.to_f / 100}"
  end

  def formatted_ivi_revenue_price
    "$#{ivi_revenue.to_f / 100}"
  end

  def self.enabled_items
    where(status: :enabled)
  end

  def self.disabled_items
    where(status: :disabled)
  end
end
