require 'rails_helper'

RSpec.describe 'Merchant_items#show', type: :feature do
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

  # User Story 7
  xit 'merchant item show page lists name, description, and selling price' do
    # As a merchant, when I click on the name of an item from the merchant items index page, (merchants/:merchant_id/items)
    visit merchant_items_path(@merchant)
    click_link "#{@item_list[0].name}"
    save_and_open_page
    # Then I am taken to that merchant's item's show page (/merchants/:merchant_id/items/:item_id)
    expect(current_path).to eq(merchant_item_path(@merchant, @item_list[0]))  
    # And I see all of the item's attributes including:
    within ".item_attributes" do
      # Name
      expect(page).to have_content("#{@item_list[0].name}")
      # Description
      expect(page).to have_content("Description: #{@item_list[0].description}")
      # Current Selling Price 
      expect(page).to have_content("Current Selling Price: #{@item_list[0].formatted_unit_price}")     
    end
  end

end