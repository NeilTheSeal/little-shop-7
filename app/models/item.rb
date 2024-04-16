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

  def formatted_created_at
    created_at.strftime("%A, %B %d, %Y")
  end

  def self.enabled_items
    where(status: :enabled)
  end

  def self.disabled_items
    where(status: :disabled)
  end

  def top_selling_date
    self
      .select("items.name, invoices.id AS invoice_id, invoices.created_at AS created_at, count(items.name)")
      .joins(:transactions)
      .where("transactions.result = '1'")
      .group("invoices.id, items.name")
      .order("name DESC, count DESC")
  end
end
