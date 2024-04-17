class Transaction < ApplicationRecord
  belongs_to :invoice
  validates :invoice, :result, :credit_card_number,
            :credit_card_expiration_date, presence: true

  enum :result, %w[failed success]
end
