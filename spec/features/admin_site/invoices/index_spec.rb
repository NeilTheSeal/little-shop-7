require "rails_helper"

RSpec.describe "Admin Invoice Show Page" do
  before(:each) do
    @merchant = create(:merchant)
    @item = create(:item, merchant: @merchant, unit_price: 1000)
    @customer = create(:customer)
    @invoice1 = create(
      :invoice,
      customer: @customer,
      created_at: "2020-01-01 00:00:00"
    )
    @invoice2 = create(
      :invoice,
      customer: @customer,
      created_at: "2021-01-01 00:00:00"
    )
    @invoice3 = create(
      :invoice,
      customer: @customer,
      created_at: "2022-01-01 00:00:00"
    )
    create(
      :invoice_item,
      item: @item,
      invoice: @invoice1,
      quantity: 1,
      unit_price: @item.unit_price
    )
    create(
      :invoice_item,
      item: @item,
      invoice: @invoice2,
      quantity: 1,
      unit_price: @item.unit_price
    )
    create(
      :invoice_item,
      item: @item,
      invoice: @invoice2,
      quantity: 1,
      unit_price: @item.unit_price
    )
    create(
      :invoice_item,
      item: @item,
      invoice: @invoice3,
      quantity: 1,
      unit_price: @item.unit_price
    )
    create(
      :invoice_item,
      item: @item,
      invoice: @invoice3,
      quantity: 1,
      unit_price: @item.unit_price
    )
    create(:transaction, invoice: @invoice1)
    create(:transaction, invoice: @invoice2)
    create(:transaction, invoice: @invoice3)
  end

  it "has a list of all invoice id's in the system" do
    visit "/admin/invoices"

    expect(page).to have_content("Invoice ##{@invoice1.id}")
    expect(page).to have_content("Invoice ##{@invoice2.id}")
    expect(page).to have_content("Invoice ##{@invoice3.id}")
  end

  it "links to the invoice show page" do
    visit "/admin/invoices"
    click_link("Invoice ##{@invoice1.id}")

    expect(page).to have_current_path("/admin/invoices/#{@invoice1.id}")
  end


end
