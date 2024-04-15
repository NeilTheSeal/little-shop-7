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
  
  # 15. Merchant Invoice Show Page
  it "merchant invoices attributes with their customer" do
    # As a merchant
    # When I visit my merchant's invoice show page (/merchants/:merchant_id/invoices/:invoice_id)
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
end 