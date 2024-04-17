require "rails_helper"

RSpec.describe "merchant dashboard", type: :feature do
  before(:each) do
    define_instance_variables
  end

  # User Story 1
  it "merchant dashboard has the merchant's name" do
    visit "/merchant/#{@merchant.id}/dashboard"

    expect(page).to have_content(@merchant.name)
  end

  # User Story 2
  it "merchant dashboard has links to merchant items and invoices" do
    visit "/merchant/#{@merchant.id}/dashboard"

    within ".merchant_items" do
      expect(page).to have_link("Merchant Items")
      click_link("Merchant Items")
      expect(current_path).to eq(merchant_items_path(@merchant))
    end

    visit "/merchant/#{@merchant.id}/dashboard"

    within ".merchant_invoices" do
      expect(page).to have_link("Merchant Invoices")
      click_link("Merchant Invoices")
      expect(current_path).to eq(merchant_invoices_path(@merchant))
    end
  end

  # User Story 3
  it "merchant dashboard shows top 5 customers, with number of successful transactions" do
    visit "/merchant/#{@merchant.id}/dashboard"

    within ".merchant_top_5_customers" do
      expect(page).to have_content("Top Five Customers")

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
    visit "/merchant/#{@merchant.id}/dashboard"

    within ".merchant_items_to_be_shipped" do
      expect(page).to have_content("Items Ready to Ship")

      expect(page).to have_content(@item_list[10].name)
      expect(page).to have_content(@item_list[0].name)
      expect(page).to_not have_content(@item_list[15].name)

      expect(page).to have_link("Invoice #{@invoice_list[10].id}")
      expect(page).to have_link("Invoice #{@invoice_list[0].id}")
    end
  end

  # User Story 5
  it "merchant dashboard has invoices for ordered items with date, sorted from oldest to newest" do
    visit "/merchant/#{@merchant.id}/dashboard"

    within ".merchant_items_to_be_shipped" do
      expect(page).to have_content("Items Ready to Ship")
      expect("Friday, January 01, 2021").to appear_before("Saturday, January 01, 2022")
    end
  end
end
