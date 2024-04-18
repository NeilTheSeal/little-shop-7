class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices
  validates :name, presence: true

  enum :status, { enabled: 0, disabled: 1 }

  def top_five_customers
    transactions
      .select("customers.id, CONCAT(customers.first_name, ' ', customers.last_name) AS customer_name, COUNT(transactions.result) AS transaction_result")
      .joins(invoice: :customer)
      .where("transactions.result = '1'")
      .group("customers.id")
      .order("transaction_result DESC")
      .limit(5)
  end

  def ready_to_ship_items
    invoice_items
      .joins(:invoice)
      .where("invoice_items.status != '2'")
      .order("invoices.created_at")
  end

  def self.top_five_merchants
    Merchant.joins(:transactions)
            .where("transactions.result = 1")
            .select("SUM(invoice_items.unit_price * invoice_items.quantity) AS total_revenue, merchants.name AS merchant_name, merchants.id")
            .group("merchants.name, merchants.id")
            .order("total_revenue DESC")
            .limit(5)
  end

  def date_of_most_revenue
    invoice_items.joins(:invoice)
                 .select(
                   "invoice_items.invoice_id, SUM(" \
                   "invoice_items.quantity * invoice_items.unit_price" \
                   ") AS total_revenue, invoices.created_at AS invoice_date"
                 )
                 .group("invoice_items.invoice_id, invoices.created_at")
                 .order("total_revenue DESC", "invoices.created_at DESC")[0]
                 .invoice_date.strftime("%A, %B %d, %Y at %l:%M %p")
  end

  def unique_invoices
    invoices.distinct
  end

  def top_five_items
    items
      .select("items.*, sum(invoice_items.quantity * invoice_items.unit_price) AS IVI_revenue, count(transactions.result)")
      .joins(:transactions)
      .group("items.name, items.id")
      .having("count(transactions.result) != '0'")
      .order("IVI_revenue DESC")
      .limit(5)
  end
end
