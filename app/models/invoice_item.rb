class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  enum :status, %w[pending packaged shipped]

  def formatted_invoice_date
    invoice.created_at.strftime("%A, %B %d, %Y")
  end

  def formatted_unit_price_invoice_item
    "$#{unit_price.to_f / 100}"
  end
end
