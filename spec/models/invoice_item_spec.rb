require("rails_helper")

RSpec.describe InvoiceItem do
  describe "model relationships" do
    it { should belong_to(:item) }
    it { should belong_to(:invoice) }
  end

  describe 'instance methods' do
    it '#formatted_invoice_date' do
      @customer = Customer.create!(first_name: "Cody", last_name: "Andrews", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09")
      @merchant = Merchant.create!(name: "Sall's Bakery")
      @cookie = Item.create!(name: "Cookie", description: "It's a good cookie.", unit_price: 251, merchant_id: @merchant.id)
      @invoice = Invoice.create!(customer_id: @customer.id, status: 1, created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09")
      @invoice_item = InvoiceItem.create!(item_id: @cookie.id, invoice_id: @invoice.id, quantity: 1, unit_price: 9, status: 0, created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09")
      expect(@invoice_item.formatted_invoice_date).to eq("Tuesday, March 27, 2012")
    end

    it '#formatted_unit_price_invoice_item' do
      @customer = Customer.create!(first_name: "Cody", last_name: "Andrews", created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09")
      @merchant = Merchant.create!(name: "Sall's Bakery")
      @cookie = Item.create!(name: "Cookie", description: "It's a good cookie.", unit_price: 251, merchant_id: @merchant.id)
      @invoice = Invoice.create!(customer_id: @customer.id, status: 1, created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09")
      @invoice_item = InvoiceItem.create!(item_id: @cookie.id, invoice_id: @invoice.id, quantity: 1, unit_price: 9, status: 0, created_at: "2012-03-27 14:54:09", updated_at: "2012-03-27 14:54:09")
      expect(@invoice_item.formatted_unit_price_invoice_item).to eq("$0.09")
    end

  end
end