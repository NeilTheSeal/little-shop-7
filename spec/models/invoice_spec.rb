require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "model relationships" do
    it { should belong_to(:customer) }
    it { should have_many(:invoice_items) }
    it { should have_many(:transactions) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
  end

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
  end

  describe "class methods" do
    xit "unshipped_invoices" do
    end
  end

  describe "instance methods" do
    it "total_revenue" do
      expect(@invoice.total_revenue).to eq(5000)
    end
  end
end
