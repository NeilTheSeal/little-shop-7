require "rails_helper"

RSpec.describe "merchant_invoices#index", type: :feature do
  before(:each) do
    @merchant = create(:merchant)
    @merchant2 = create(:merchant)
    @customer_list = create_list(:customer, 6)
    @item_list = create_list(:item, 21, merchant: @merchant)
    @item_list2 = create_list(:item, 21, merchant: @merchant,
                                         status: "disabled")

    @invoice_list = []
    @invoice_list << create(:invoice, customer: @customer_list[0],
                                      created_at: "2022-01-01 00:00:00")
    2.times do
      @invoice_list << create(:invoice, customer: @customer_list[1],
                                        created_at: "2021-01-01 00:00:00")
    end
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

  # User Story 14
  it "merchant invoices link to its show page" do
    # As a merchant, when I visit my merchant's invoices index (/merchants/:merchant_id/invoices)
    visit merchant_invoices_path(@merchant)

    within ".merchant_invoices" do
      # Then I see all of the invoices that include at least one of my merchant's items
      within "#invoice-#{@invoice_list[0].id}" do
        # And for each invoice I see its id
        expect(page).to have_link("#{@invoice_list[0].id}")
      end
      within "#invoice-#{@invoice_list[1].id}" do
        expect(page).to have_link("#{@invoice_list[1].id}")
        click_link("#{@invoice_list[1].id}")
      end
      # And each id links to the merchant invoice show page
      expect(current_path).to eq(merchant_invoice_path(@merchant,
                                                       @invoice_list[1]))
    end
  end
end
