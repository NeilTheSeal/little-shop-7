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
end
