class Customer < ApplicationRecord
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :items, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :merchants, through: :items

  def self.top_customers
    Customer.select(
      "customers.first_name, customers.last_name, customers.id," \
      "COUNT(customers.id) AS transaction_count"
    )
            .joins(:transactions)
            .where("transactions.result = 1")
            .group("customers.id")
            .order("COUNT(customers.id) DESC")
            .limit(5)
  end
end
