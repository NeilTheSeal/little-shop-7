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
      status: "completed",
      created_at: "2022-01-01 00:00:00"
    )
    create(
      :invoice_item,
      item: @item1,
      invoice: @invoice,
      quantity: 2,
      unit_price: @item1.unit_price
    )
    create(
      :invoice_item,
      item: @item2,
      invoice: @invoice,
      quantity: 2,
      unit_price: @item2.unit_price
    )

    create(:transaction, invoice: @invoice)
  end

  it "shows information related to that invoice" do
    visit "/admin/invoices/#{@invoice.id}"

    expect(page).to have_content("Invoice ##{@invoice.id}")
    expect(page).to have_content("Status: completed")
    expect(page).to have_content("Created At: Saturday, January 01, 2022")
    expect(page).to have_content("Customer Name: #{@customer.first_name} #{@customer.last_name}")
  end
end
