require "csv"

namespace :csv_load do
  task customers: [:environment] do
    print "."
    file_path = "db/data/customers.csv"
    Customer.destroy_all
    CSV.foreach(file_path, headers: true) do |row|
      Customer.create!(row.to_hash)
    end
  end

  task merchants: [:environment] do
    print "."
    file_path = "db/data/merchants.csv"
    Merchant.destroy_all
    CSV.foreach(file_path, headers: true) do |row|
      Merchant.create!(row.to_hash)
    end
  end

  task invoices: [:environment] do
    print "."
    file_path = "db/data/invoices.csv"
    Invoice.destroy_all
    CSV.foreach(file_path, headers: true) do |row|
      Invoice.create!(row.to_hash)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!("invoice")
  end

  task items: [:environment] do
    print "."
    file_path = "db/data/items.csv"
    Item.destroy_all
    CSV.foreach(file_path, headers: true) do |row|
      Item.create!(row.to_hash)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!("items")
  end

  task invoice_items: [:environment] do
    print "."
    file_path = "db/data/invoice_items.csv"
    InvoiceItem.destroy_all
    CSV.foreach(file_path, headers: true) do |row|
      InvoiceItem.create!(row.to_hash)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!("invoice_items")
  end

  task transactions: [:environment] do
    print "."
    file_path = "db/data/transactions.csv"
    Transaction.destroy_all
    CSV.foreach(file_path, headers: true) do |row|
      Transaction.create!(row.to_hash)
    end
    ActiveRecord::Base.connection.reset_pk_sequence!("transactions")
  end

  task all: [:environment] do
    print "Loading CSVs"
    Rake::Task["csv_load:customers"].invoke
    Rake::Task["csv_load:merchants"].invoke
    Rake::Task["csv_load:invoices"].invoke
    Rake::Task["csv_load:items"].invoke
    Rake::Task["csv_load:invoice_items"].invoke
    Rake::Task["csv_load:transactions"].invoke
    puts "\nCSVs Loaded Successfully"
  end
end
