require("faker")

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

FactoryBot.define do
  factory :customer, class: Customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end

  factory :merchant, class: Merchant do
    name { Faker::Cannabis.brand }
  end

  factory :invoice, class: Invoice do
    status { 0 }
  end

  factory :item, class: Item do
    name { Faker::Food.dish }
    description { Faker::Hipster.paragraph(sentence_count: 2) }
    unit_price { rand(500..10_000) }
  end

  factory :invoice_item, class: InvoiceItem do
    quantity { rand(1..10) }
    status { 0 }
  end

  factory :transaction, class: Transaction do
    credit_card_number { Faker::Business.credit_card_number }
    credit_card_expiration_date do
      Faker::Business.credit_card_expiry_date.strftime("%m/%y")
    end
    result { 1 }
  end
end
