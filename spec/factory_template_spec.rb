require("rails_helper")

RSpec.describe "factory template" do
  before(:each) do
    @customer = create(:customer)

    @merchant = create(:merchant)

    @invoice = create(:invoice, customer: @customer)
    @invoice_list = create_list(:invoice, 5, customer: @customer)

    @item = create(:item, merchant: @merchant)
    @item_list = create_list(:item, 5, merchant: @merchant)

    @invoice_item = create(
      :invoice_item,
      item: @item,
      invoice: @invoice,
      unit_price: @item.unit_price
    )

    @invoice_items_list = create_list(
      :invoice_item,
      5,
      item: @item_list[0],
      invoice: @invoice_list[0],
      unit_price: @item_list[0].unit_price
    )

    @transaction = create(:transaction, invoice: @invoice_list[0])
  end

  it "examples" do
    # p @customer
    # p @merchant
    # p @invoice
    # p @invoice_list[0]
    # p @item
    # p @item_list[0]
    # p @invoice_item
    # p @invoice_items_list[0]
    # p @transaction
  end
end
