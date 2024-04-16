class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  enum :status, %w[enabled disabled]

  def top_five_customers
    transactions.joins(invoice: :customer)
                .where("transactions.result = '1'")
                .select("customers.id, CONCAT(customers.first_name, ' ', customers.last_name) AS customer_name, COUNT(transactions.result) AS transaction_result")
                .group("customers.id")
                .order("transaction_result DESC")
                .limit(5)
  end

  def ready_to_ship_items
    invoice_items.joins(:invoice).where("invoice_items.status != '2'")
                 .order("invoices.created_at")
  end

  def unique_invoices
    self.invoices.distinct
  end

  def top_five_items
    self.items
      .select("items.*, sum(invoice_items.quantity * invoice_items.unit_price) AS IVI_revenue, count(transactions.result)")
      .joins("
        JOIN merchants ON items.merchant_id = merchants.id
        JOIN invoice_items ON items.id = invoice_items.item_id
        JOIN invoices ON invoice_items.invoice_id = invoices.id
        JOIN transactions ON invoices.id = transactions.invoice_id")
      .group("items.name, items.id")
      .having("count(transactions.result) != '0'")
      .order("IVI_revenue DESC")
      .limit(5)
  end
end
