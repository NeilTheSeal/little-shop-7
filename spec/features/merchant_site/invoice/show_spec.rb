require 'rails_helper'

RSpec.describe 'merchant_invoices#index', type: :feature do
  before(:each) do
    @merchant = create(:merchant)
    @merchant2 = create(:merchant)

    @customer_list = create_list(:customer, 6)

    @item_list = create_list(:item, 21, merchant: @merchant)
    @item_list2 = create_list(:item, 21, merchant: @merchant, status: "disabled")

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
                                                  invoice: @invoice_list[index], unit_price: 200, quantity: 8, status: "packaged")
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
  
  # User Story 15
  it "merchant invoices attributes with their customer" do
    # As a merchant, when I visit my merchant's invoice show page (/merchants/:merchant_id/invoices/:invoice_id)
    visit merchant_invoice_path(@merchant, @invoice_list[0])
    # Then I see information related to that invoice including:
    # save_and_open_page
    within '.invoice_attributes' do
      # - Invoice id
      expect(page).to have_content(@invoice_list[0].id)
      # - Invoice status
      expect(page).to have_content(@invoice_list[0].status)
      # - Invoice created_at date in the format "Monday, July 18, 2019"
      expect(page).to have_content(@invoice_list[0].created_at.strftime("%A, %B %d, %Y"))
    end
    # - Customer first and last name
    expect(page).to have_content(@customer_list[0].first_name)
    expect(page).to have_content(@customer_list[0].last_name)      
  end

  # User Story 16
  it "Invoice Item Information" do
  # As a merchant, when I visit my merchant invoice show page (/merchants/:merchant_id/invoices/:invoice_id)
  visit merchant_invoice_path(@merchant, @invoice_list[0])
  # Then I see all of my items on the invoice including:
  within '.invoice_item_info' do
    # - Item name
    expect(page).to have_content(@item_list[0].name)
    # - The quantity of the item ordered
    expect(page).to have_content(@invoice_item_list[0].quantity)
    # - The price the Item sold for
    expect(page).to have_content(@invoice_item_list[0].formatted_unit_price_invoice_item)
    # - The Invoice Item status
    expect(page).to have_content(@invoice_item_list[0].status)    
  end
  # And I do not see any information related to Items for other merchants
  end

  # 17. Merchant Invoice Show Page: Total Revenue
  it "total revenue for the invoice item" do
    # As a merchant
    # When I visit my merchant invoice show page (/merchants/:merchant_id/invoices/:invoice_id)
    visit merchant_invoice_path(@merchant, @invoice_list[0])
    # Then I see the total revenue that will be generated from all of my items on the invoice
    within '.total_revenue' do
      expect(page).to have_content("Total Revenue: 1600")
    end
  end
  
  # 18. Merchant Invoice Show Page: Update Item Status
  it "update invoice item status" do
    # As a merchant
    # When I visit my merchant invoice show page (/merchants/:merchant_id/invoices/:invoice_id)
    visit merchant_invoice_path(@merchant, @invoice_list[0])
    # I see that each invoice item status is a select field
    # And I see that the invoice item's current status is selected
    within "#invoice_item-#{@invoice_item_list[0].id}" do
      expect(page).to have_content(@invoice_item_list[0].status)
      expect(page).to have_select("status")
      # When I click this select field,
      # Then I can select a new status for the Item,
      select("pending", from: "status")
      # And next to the select field I see a button to "Update Item Status"
      expect(page).to have_content("Update Item Status")
      # When I click this button
      click_button("Update Item Status")
    end
    # I am taken back to the merchant invoice show page
    expect(current_path).to eq(merchant_invoice_path(@merchant, @invoice_list[0]))
    # And I see that my Item's status has now been updated
    within "#invoice_item-#{@invoice_item_list[0].id}" do
      expect(page).to have_content("pending")
    end
  end
end 