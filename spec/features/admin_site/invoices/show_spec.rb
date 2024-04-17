require("rails_helper")

RSpec.describe "Admin Index Show Page" do
  before(:each) do
    @merchant = create(:merchant)
    @item1 = create(:item, merchant: @merchant, unit_price: 1000)
    @item2 = create(:item, merchant: @merchant, unit_price: 2000)
    @customer = create(:customer)

    @invoice = create(
      :invoice,
      customer: @customer,
      status: "in progress",
      created_at: "2022-01-01 00:00:00"
    )
    create(
      :invoice_item,
      item: @item1,
      invoice: @invoice,
      quantity: 1,
      unit_price: @item1.unit_price,
      status: "pending"
    )
    create(
      :invoice_item,
      item: @item2,
      invoice: @invoice,
      quantity: 2,
      unit_price: @item2.unit_price,
      status: "packaged"
    )

    create(:transaction, invoice: @invoice)
  end

  it "shows information related to that invoice" do
    visit "/admin/invoices/#{@invoice.id}"

    expect(page).to have_content("Invoice ##{@invoice.id}")
    expect(page).to have_content("Status: ")
    expect(page).to have_content("Created At: Saturday, January 01, 2022")
    expect(page).to have_content("Customer Name: #{@customer.first_name} #{@customer.last_name}")
    expect(page).to have_content("Total Revenue: $50.00")
  end

  it "shows all items on the invoice and all invoice item information" do
    visit "/admin/invoices/#{@invoice.id}"

    within "#invoice-items" do
      expect(page).to have_content(@item1.name)
      expect(page).to have_content("Quantity: 2")
      expect(page).to have_content("Unit Price: $10.00")
      expect(page).to have_content("Status: pending")

      expect(page).to have_content(@item2.name)
      expect(page).to have_content("Quantity: 1")
      expect(page).to have_content("Unit Price: $20.00")
      expect(page).to have_content("Status: packaged")
    end
  end

  it "has a form to update invoice status" do
    visit "/admin/invoices/#{@invoice.id}"

    within("form") do
      expect(page).to have_select(
        "status",
        selected: "in progress",
        options: ["cancelled", "in progress", "completed"]
      )
      expect(page).to have_button("update")
    end
  end

  it "can update the status of an invoice" do
    visit "/admin/invoices/#{@invoice.id}"

    select "completed", from: "status"
    click_button("update")

    expect(page).to have_current_path("/admin/invoices/#{@invoice.id}")

    expect(page).to have_select(
      "status",
      selected: "completed",
      options: ["cancelled", "in progress", "completed"]
    )
  end
end
