class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices
  validates :name, :description, :unit_price, :status, presence: true

  enum status: %w[enabled disabled]

  def self.enabled_items
    where(status: :enabled)
  end

  def self.disabled_items
    where(status: :disabled)
  end

  def top_selling_date
    invoice_items.joins(invoice: :transactions)
                 .where("transactions.result = '1'")
                 .select(
                   "DATE_TRUNC('day', invoices.created_at) AS invoice_date," \
                   " SUM(invoice_items.quantity) AS total_sold"
                 ).group("DATE_TRUNC('day',invoices.created_at)")
                 .order("total_sold DESC, invoice_date DESC")
                 .limit(1)[0]
                 .invoice_date.strftime("%A, %B %d, %Y")
  end

  def formatted_unit_price
    "$#{unit_price.to_f / 100}"
  end

  # def formatted_ivi_revenue_price
  #   "$#{ivi_revenue.to_f / 100}"
  # end

  def formatted_created_at
    created_at.strftime("%A, %B %d, %Y")
  end
end
