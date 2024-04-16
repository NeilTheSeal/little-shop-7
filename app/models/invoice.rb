class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :invoice_items
  has_many :transactions
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum :status, ["cancelled", "in progress", "completed"]

  def self.unshipped_invoices
    self
      .joins(:invoice_items)
      .where("invoice_items.status != 2")
      .group("invoices.id")
      .order(:created_at)
  end
end
