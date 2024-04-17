require "rails_helper"

RSpec.describe "merchant dashboard", type: :feature do
  before(:each) do
    @merchant = create(:merchant)

    @customer_list = create_list(:customer, 6)

    @item_list = create_list(:item, 21, merchant: @merchant)

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

  # User Story 1
  it "merchant dashboard has the merchant's name" do
    # As a merchant, when I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
    visit "/merchant/#{@merchant.id}/dashboard"

    # I see the name of my merchant
    expect(page).to have_content(@merchant.name)
  end

  # User Story 2
  xit "merchant dashboard has links to merchant items and invoices" do
    # As a merchant, when I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
    visit "/merchant/#{@merchant.id}/dashboard"

    # I see link to my merchant items index (/merchants/:merchant_id/items)
    within ".merchant_items" do
      expect(page).to have_link("Merchant Items")
      click_link("Merchant Items")
      expect(current_path).to eq(merchant_items_path(@merchant))
    end

    visit "/merchant/#{@merchant.id}/dashboard"

    # And I see a link to my merchant invoices index (/merchants/:merchant_id/invoices)
    within ".merchant_invoices" do
      expect(page).to have_link("Merchant Invoices")
      click_link("Merchant Invoices")
      expect(current_path).to eq(merchant_invoices_path(@merchant))
    end
  end

  # User Story 3
  xit "merchant dashboard shows top 5 customers, with number of successful transactions" do
    # As a merchant, when I visit my merchant dashboard (/merchants/:merchant_id/dashboard)

    visit "/merchant/#{@merchant.id}/dashboard"
    # save_and_open_page
    # Then I see the names of the top 5 customers who have conducted the largest number of successful transactions with my merchant
    within ".merchant_top_5_customers" do
      expect(page).to have_content("Top Five Customers")
      # And next to each customer name I see the number of successful transactions they have conducted with my merchant
      expect(@customer_list[5].first_name).to appear_before(@customer_list[4].first_name)
      expect(@customer_list[4].first_name).to appear_before(@customer_list[3].first_name)
      expect(@customer_list[3].first_name).to appear_before(@customer_list[2].first_name)
      expect(@customer_list[2].first_name).to appear_before(@customer_list[1].first_name)

      expect(@customer_list[5].last_name).to appear_before(@customer_list[4].last_name)
      expect(@customer_list[4].last_name).to appear_before(@customer_list[3].last_name)
      expect(@customer_list[3].last_name).to appear_before(@customer_list[2].last_name)
      expect(@customer_list[2].last_name).to appear_before(@customer_list[1].last_name)
    end
  end

  # User Story 4
  it "merchant dashboard has list of names of items that have been ordered but not shipped" do
    # As a merchant, when I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
    visit "/merchant/#{@merchant.id}/dashboard"
    # save_and_open_page
    # Then I see a section for "Items Ready to Ship"
    within ".merchant_items_to_be_shipped" do
      expect(page).to have_content("Items Ready to Ship")
      # In that section I see a list of the names of all of my items that have been ordered and have not yet been shipped,
      expect(page).to have_content(@item_list[10].name)
      expect(page).to have_content(@item_list[0].name)
      expect(page).to_not have_content(@item_list[15].name)
      # And next to each Item I see the id of the invoice that ordered my item
      # And each invoice id is a link to my merchant's invoice show page
      expect(page).to have_link("Invoice #{@invoice_list[10].id}")
      expect(page).to have_link("Invoice #{@invoice_list[0].id}")
    end
  end

  # User Story 5
  it "merchant dashboard has invoices for ordered items with date, sorted from oldest to newest" do
    # As a merchant, when I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
    visit "/merchant/#{@merchant.id}/dashboard"
    # save_and_open_page
    # In the section for "Items Ready to Ship",
    within ".merchant_items_to_be_shipped" do
      expect(page).to have_content("Items Ready to Ship")
      # Next to each Item name I see the date that the invoice was created
      # And I see the date formatted like "Monday, July 18, 2019"
      # And I see that the list is ordered from oldest to newest
      expect("Friday, January 01, 2021").to appear_before("Saturday, January 01, 2022")
    end
  end
end
