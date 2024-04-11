class Customer < ApplicationRecord
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :items, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :merchants, through: :items

  def top_customer_id
    # Customer.joins(:transactions)
      # .where("transactions.result='success'")
      # .order("count_all DESC")
      # .limit(5)
      # .group("customers.id").count
    Customer.select("customers.first_name, customers.last_name, customers.id, COUNT(customers.id)")
      .joins(:transactions)
      .where("transactions.result = 'success'")
      .group("customers.id")
      .order("COUNT(customers.id) DESC")
      .limit(5)
  end

end
