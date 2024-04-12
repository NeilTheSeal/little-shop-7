require 'rails_helper'

RSpec.describe Merchant, type: :model do
  # describe 'validations' do
  #   xit { should validate_presence_of :}
  # end

  # describe 'relationships' do
  #   it {should belong_to :}
  #   it {should have_many :}
  # end
  before(:each) do
    @merchant = create(:merchant)

    @customer_list = create_list(:customer, 6)

    @item_list = create_list(:item, 21, merchant: @merchant)

    @invoice_list = []
    @invoice_list << create(:invoice, customer: @customer_list[0])
    2.times { @invoice_list << create(:invoice, customer: @customer_list[1])}
    3.times { @invoice_list << create(:invoice, customer: @customer_list[2]) }
    4.times { @invoice_list << create(:invoice, customer: @customer_list[3]) }
    5.times { @invoice_list << create(:invoice, customer: @customer_list[4]) }
    6.times { @invoice_list << create(:invoice, customer: @customer_list[5]) }

    @invoice_item_list = []
    @item_list.each_with_index do |item, index|
      @invoice_item_list << create(:invoice_item, item: item, invoice: @invoice_list[index], unit_price: item.unit_price)
    end
    @transaction_list = []
    @invoice_list.each_with_index do |invoice, index|
      @transaction_list << create(:transaction, invoice: invoice)
    end

  end
  describe 'instance methods' do
    it "list the top 5 customers for each merchant" do
      top_five = @merchant.top_five_customers 
      expect(top_five[0].customer_name).to eq(@customer_list[5].first_name.concat(" #{@customer_list[5].last_name}"))
      expect(top_five[1].customer_name).to eq(@customer_list[4].first_name.concat(" #{@customer_list[4].last_name}"))
      expect(top_five[2].customer_name).to eq(@customer_list[3].first_name.concat(" #{@customer_list[3].last_name}"))
      expect(top_five[3].customer_name).to eq(@customer_list[2].first_name.concat(" #{@customer_list[2].last_name}"))
      expect(top_five[4].customer_name).to eq(@customer_list[1].first_name.concat(" #{@customer_list[1].last_name}"))
    end

    it "#rts_items" do
      expect(@merchant.rts_items).to eq(@invoice_item_list)
    end
  end
end