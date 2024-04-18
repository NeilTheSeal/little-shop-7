class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items
  has_many :transactions
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  validates :status, presence: true

  enum :status, { cancelled: 0, "in progress": 1, completed: 2 }

  def self.unshipped_invoices
    joins(:invoice_items)
      .where("invoice_items.status != 2")
      .group("invoices.id")
      .order(:created_at)
  end

  def total_revenue
    invoice_items.select(
      "SUM(invoice_items.quantity * invoice_items.unit_price)" \
      " AS total_revenue, invoice_items.invoice_id"
    ).group("invoice_items.invoice_id")[0].total_revenue
  end
end
