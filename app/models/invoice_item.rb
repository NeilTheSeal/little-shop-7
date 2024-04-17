class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  validates :quantity, :unit_price, :status, presence: true

  enum :status, %w[pending packaged shipped]

  def formatted_invoice_date
    invoice.created_at.strftime("%A, %B %d, %Y")
  end
end
