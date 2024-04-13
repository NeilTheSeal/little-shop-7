require 'rails_helper'

RSpec.describe 'Merchant_items#index', type: :feature do
  before(:each) do
    @merchant = create(:merchant)
    @merchant2 = create(:merchant)

    @customer_list = create_list(:customer, 6)

    @item_list = create_list(:item, 21, merchant: @merchant)
    @item_list2 = create_list(:item, 21, merchant: @merchant2)

    @invoice_list = []
    @invoice_list << create(:invoice, customer: @customer_list[0], created_at: "2022-01-01 00:00:00")
    2.times { @invoice_list << create(:invoice, customer: @customer_list[1], created_at: "2021-01-01 00:00:00")}
    3.times { @invoice_list << create(:invoice, customer: @customer_list[2]) }
    4.times { @invoice_list << create(:invoice, customer: @customer_list[3]) }
    5.times { @invoice_list << create(:invoice, customer: @customer_list[4]) }
    6.times { @invoice_list << create(:invoice, customer: @customer_list[5]) }

    @invoice_item_list = []
    @item_list.each_with_index do |item, index|
      if index < 10
        @invoice_item_list << create(:invoice_item, item:,
                                                  invoice: @invoice_list[index], unit_price: item.unit_price, status: "packaged")
      elsif index < 15
        @invoice_item_list << create(:invoice_item, item:,
                                                  invoice: @invoice_list[index], unit_price: item.unit_price, status: "pending")
      else 
        @invoice_item_list << create(:invoice_item, item:,
                                                    invoice: @invoice_list[index], unit_price: item.unit_price, status: "shipped")
      end
    end
    @transaction_list = []
    @invoice_list.each_with_index do |invoice, index|
      @transaction_list << create(:transaction, invoice:)
    end
  end

  # 6. Merchant Items Index Page
  it "list of all the names" do
  # As a merchant,
  # When I visit my merchant items index page (merchants/:merchant_id/items)
  visit merchant_items_path(@merchant)
  # I see a list of the names of all of my items
  within '.name_of_items' do
    expect(page).to have_content(@item_list[0].name)
    expect(page).to have_content(@item_list[1].name)
    expect(page).to have_content(@item_list[2].name)
    expect(page).to have_content(@item_list[3].name)
    expect(page).to have_content(@item_list[4].name)
  end
  # And I do not see items for any other merchant
  expect(page).to_not have_content(@item_list2[0].name) # We might need to fix - random data everytime, hard to eliminate certain items
  end
end