require "rails_helper"

RSpec.describe "merchant_invoices#index", type: :feature do
  before(:each) do
    define_instance_variables
  end

  # User Story 15
  it "merchant invoices attributes with their customer" do
    visit merchant_invoice_path(@merchant, @invoice_list[0])

    within ".invoice_attributes" do
      expect(page).to have_content(@invoice_list[0].id)
      expect(page).to have_content(@invoice_list[0].status)
      expect(page).to have_content("Saturday, January 01, 2022")
    end

    expect(page).to have_content(@customer_list[0].first_name)
    expect(page).to have_content(@customer_list[0].last_name)
  end

  # User Story 16
  it "Invoice Item Information" do
    visit merchant_invoice_path(@merchant, @invoice_list[0])

    within ".invoice_item_info" do
      expect(page).to have_content(@item_list[0].name)
      expect(page).to have_content("Quantity: 1")
      expect(page).to have_content("Price: $10.00")
      expect(page).to have_content("Status: packaged")
    end
  end

  # 17. Merchant Invoice Show Page: Total Revenue
  it "total revenue for the invoice item" do
    visit merchant_invoice_path(@merchant, @invoice_list[0])

    within ".total_revenue" do
      expect(page).to have_content("Total Revenue: $10.00")
    end
  end

  # 18. Merchant Invoice Show Page: Update Item Status
  it "update invoice item status" do
    visit merchant_invoice_path(@merchant, @invoice_list[0])

    within "#invoice_item-#{@invoice_item_list[0].id}" do
      expect(page).to have_content(@invoice_item_list[0].status)
      expect(page).to have_select("status")

      select("pending", from: "status")
      expect(page).to have_content("Update Item Status")

      click_button("Update Item Status")
    end

    expect(current_path).to eq(
      merchant_invoice_path(@merchant, @invoice_list[0])
    )

    within "#invoice_item-#{@invoice_item_list[0].id}" do
      expect(page).to have_content("pending")
    end
  end
end
