class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def top_five_customers
    transactions.joins(invoice: :customer)
      .where("transactions.result = '1'")      
      .select("customers.id, CONCAT(customers.first_name, ' ', customers.last_name) AS customer_name, COUNT(transactions.result) AS transaction_result")
      .group("customers.id")
      .order("transaction_result DESC")
      .limit(5)
  end

end

# SELECT merchants.id AS merchant_id, merchants.name AS merchants_name, customers.id AS customer_id, customers.first_name, customers.last_name, count(transactions.result) AS transaction_result

# FROM customers
# JOIN invoices ON invoices.customer_id = customers.id
# JOIN transactions ON transactions.invoice_id = invoices.id
# JOIN invoice_items ON invoice_items.invoice_id = invoices.id
# JOIN items ON items.id = invoice_items.item_id
# JOIN merchants ON merchants.id = items.merchant_id

# WHERE transactions.result = '1' AND merchants.id = '1'

# GROUP BY merchants.id, customers.id

# ORDER BY merchants.id, transaction_result DESC
# LIMIT 5;