class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  enum :status, %w[pending packaged shipped]

  def formatted_invoice_date
    invoice.created_at.strftime("%A, %B %d, %Y")
  end
end
