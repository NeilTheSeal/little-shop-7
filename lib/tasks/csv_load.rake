require 'CSV'

namespace :csv_load do
  task :customers => [:environment] do
    file_path = "db/data/customers.csv"
    CSV.foreach(file_path, headers: true) do |row|
      Customer.create!(row.to_hash)
    end
  end

  task :merchants => [:environment] do
    file_path = "db/data/merchants.csv"
    CSV.foreach(file_path, headers: true) do |row|
      Merchant.create!(row.to_hash)
    end
  end  

  task :invoices => [:environment] do
    file_path = "db/data/invoices.csv"
    CSV.foreach(file_path, headers: true) do |row|
      Invoice.create!(row.to_hash)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('invoice')
  end

  task :items => [:environment] do
    file_path = "db/data/items.csv"
    CSV.foreach(file_path, headers: true) do |row|
      Item.create!(row.to_hash)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('items')
  end

  task :invoice_items => [:environment] do
    file_path = "db/data/invoice_items.csv"
    CSV.foreach(file_path, headers: true) do |row|
      InvoiceItem.create!(row.to_hash)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
  end

  task :transactions => [:environment] do
    file_path = "db/data/transactions.csv"
    CSV.foreach(file_path, headers: true) do |row|
      Transaction.create!(row.to_hash)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('transactions')
  end
end
