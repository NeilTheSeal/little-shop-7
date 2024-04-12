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

  def rts_items #ready_to_ship
    self.invoice_items.joins(:invoice).where("invoice_items.status != '2'") #items.joins(:invoices)
  end
end