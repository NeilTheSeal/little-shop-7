require("rails_helper")

RSpec.describe Item do
  describe "model relationships" do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe "class methods" do
    it '#enabled_items' do
      @merchant = Merchant.create!(name: "Sally's Bakery")
      @cookie = Item.create!(name: "Cookie", description: "It's a good cookie.", unit_price: 251, merchant_id: @merchant.id, status: 0)
      @shake = Item.create!(name: "Shake", description: "It's a good shake.", unit_price: 951, merchant_id: @merchant.id, status: 1)
      @candy = Item.create!(name: "Candy", description: "It's a good candy.", unit_price: 1151, merchant_id: @merchant.id, status: 0)
      expect(Item.enabled_items).to eq([@cookie, @candy])
    end

    it '#disabled_items' do
      @merchant = Merchant.create!(name: "Sally's Bakery")
      @cookie = Item.create!(name: "Cookie", description: "It's a good cookie.", unit_price: 251, merchant_id: @merchant.id, status: 1)
      @shake = Item.create!(name: "Shake", description: "It's a good shake.", unit_price: 951, merchant_id: @merchant.id, status: 1)
      @candy = Item.create!(name: "Candy", description: "It's a good candy.", unit_price: 1151, merchant_id: @merchant.id, status: 0)
      expect(Item.disabled_items).to eq([@cookie, @shake])
    end 
  end

  describe "instance methods" do
    xit '#top_selling_date' do
    end

    it '#formatted_unit_price' do
      @merchant = Merchant.create!(name: "Sally's Bakery")
      @cookie = Item.create!(name: "Cookie", description: "It's a good cookie.", unit_price: 251, merchant_id: @merchant.id)
      expect(@cookie.formatted_unit_price).to eq("$2.51")
    end
    
    xit '#formatted_ivi_revenue_price' do
      @merchant = Merchant.create!(name: "Sally's Bakery")
      @customer = Customer.create!(first_name: "Jared", last_name: "Hobson")
      @cookie = Item.create!(name: "Cookie", description: "It's a good cookie.", unit_price: 251, merchant_id: @merchant.id)
      @invoice = Invoice.create!(customer_id: @customer.id, status: 1)
      @new_ivi = InvoiceItem.create!(item_id: @cookie.id, invoice_id: @invoice.id, quantity: 24, unit_price: 12314, status: 0)
      expect(@cookie.formatted_ivi_revenue_price).to eq("asdasdasdasd")
    end

    it '#formatted_created_at' do
      @merchant = Merchant.create!(name: "Sally's Bakery")
      @cookie = Item.create!(name: "Cookie", description: "It's a good cookie.", unit_price: 251, merchant_id: @merchant.id)
      expect(@cookie.formatted_created_at).to eq("Wednesday, April 17, 2024")
    end
  end
end