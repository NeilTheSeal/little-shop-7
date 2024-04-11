class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  #self.find_by_sql("SELECT * FROM merchants JOIN items ON merchants.id = items.merchant_id JOIN invoice_items ON items.id = invoice_items.item_id JOIN invoices ON invoices.id = invoice_items.invoice_id JOIN transactions ON transactions.invoice_id = invoices.id JOIN customers on customers.id = invoices.customer_id").where("")

#   Merchant.find_by_sql("SELECT *FROM merchants JOIN items ON merchants.id = items.merchant
# _id JOIN invoice_items ON items.id = invoice_items.item_id JOIN invoices ON invoices.id = invoice_items.i
# nvoice_id JOIN transactions ON transactions.invoice_id = invoices.id JOIN customers on customers.id = inv
# oices.customer_id").count

# SELECT *
# FROM merchants
# JOIN items ON merchants.id = items.merchant_id
# JOIN invoice_items ON items.id = invoice_items.item_id
# JOIN invoices ON invoices.id = invoice_items.invoice_id
# JOIN transactions ON transactions.invoice_id = invoices.id
# JOIN customers on customers.id = invoices.customer_id
# WHERE merchant_id = 1;

end
