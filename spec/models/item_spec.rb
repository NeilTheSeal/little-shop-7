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
    before(:each) do
      @merchant = Merchant.create!(name: "Sally's Bakery")

      @cookie = Item.create!(
        name: "Cookie",
        description: "It's a good cookie.",
        unit_price: 251,
        merchant_id: @merchant.id,
        status: 0
      )

      @shake = Item.create!(
        name: "Shake",
        description: "It's a good shake.",
        unit_price: 951,
        merchant_id: @merchant.id,
        status: 1
      )

      @candy = Item.create!(
        name: "Candy",
        description: "It's a good candy.",
        unit_price: 1151,
        merchant_id: @merchant.id,
        status: 0
      )

      @burger = Item.create!(
        name: "Burger",
        description: "It's a good burger.",
        unit_price: 351,
        merchant_id: @merchant.id,
        status: 1
      )
    end

    it "#enabled_items" do
      expect(Item.enabled_items).to eq([@cookie, @candy])
    end

    it "#disabled_items" do
      expect(Item.disabled_items).to eq([@shake, @burger])
    end
  end

  describe "instance methods" do
    it "#formatted_unit_price" do
      merchant = Merchant.create!(name: "Sally's Bakery")
      cookie = Item.create!(
        name: "Cookie",
        description: "It's a good cookie.",
        unit_price: 251,
        merchant_id: merchant.id
      )
      expect(cookie.formatted_unit_price).to eq("$2.51")
    end

    it "#top_selling_date" do
      merchant = create(:merchant)
      item = create(:item, unit_price: 1000, merchant:)
      customer = create(:customer)

      invoice1 = create(
        :invoice,
        customer:,
        created_at: "2020-01-01 00:00:00"
      )
      invoice2 = create(
        :invoice,
        customer:,
        created_at: "2020-01-01 05:00:00"
      )
      invoice3 = create(
        :invoice,
        customer:,
        created_at: "2020-01-02 00:00:00"
      )
      invoice4 = create(
        :invoice,
        customer:,
        created_at: "2020-01-03 00:00:00"
      )
      invoice5 = create(
        :invoice,
        customer:,
        created_at: "2020-01-03 02:00:00"
      )
      invoice6 = create(
        :invoice,
        customer:,
        created_at: "2020-01-04 00:00:00"
      )
      invoice7 = create(
        :invoice,
        customer:,
        created_at: "2020-01-04 02:00:00"
      )

      invoice_item1 = create(
        :invoice_item,
        item:,
        invoice: invoice1,
        unit_price: item.unit_price,
        quantity: 2
      )
      invoice_item2 = create(
        :invoice_item,
        item:,
        invoice: invoice2,
        unit_price: item.unit_price,
        quantity: 2
      )
      invoice_item3 = create(
        :invoice_item,
        item:,
        invoice: invoice3,
        unit_price: item.unit_price,
        quantity: 3
      )
      invoice_item4 = create(
        :invoice_item,
        item:,
        invoice: invoice4,
        unit_price: item.unit_price,
        quantity: 2
      )
      invoice_item5 = create(
        :invoice_item,
        item:,
        invoice: invoice5,
        unit_price: item.unit_price,
        quantity: 2
      )
      invoice_item6 = create(
        :invoice_item,
        item:,
        invoice: invoice6,
        unit_price: item.unit_price,
        quantity: 2
      )
      invoice_item7 = create(
        :invoice_item,
        item:,
        invoice: invoice7,
        unit_price: item.unit_price,
        quantity: 2
      )
      transaction1 = create(
        :transaction,
        invoice: invoice1,
        result: "success"
      )
      transaction2 = create(
        :transaction,
        invoice: invoice2,
        result: "success"
      )
      transaction3 = create(
        :transaction,
        invoice: invoice3,
        result: "success"
      )
      transaction4 = create(
        :transaction,
        invoice: invoice4,
        result: "success"
      )
      transaction5 = create(
        :transaction,
        invoice: invoice5,
        result: "success"
      )
      transaction6 = create(
        :transaction,
        invoice: invoice6,
        result: "failed"
      )
      transaction7 = create(
        :transaction,
        invoice: invoice7,
        result: "failed"
      )

      expect(item.top_selling_date).to eq("Friday, January 03, 2020")
    end

    describe "formatting" do
      before(:each) do
        @merchant = Merchant.create!(name: "Sally's Bakery")
        @customer = Customer.create!(
          first_name: "Jared",
          last_name: "Hobson"
        )
        @cookie = Item.create!(
          name: "Cookie",
          description: "It's a good cookie.",
          unit_price: 251,
          merchant_id: @merchant.id,
          created_at: "2024-04-17 00:00:00"
        )
        @invoice = Invoice.create!(
          customer_id: @customer.id,
          status: 1
        )
        @new_ivi = InvoiceItem.create!(
          item_id: @cookie.id,
          invoice_id: @invoice.id,
          quantity: 24,
          unit_price: 12_314,
          status: 0
        )
      end

      xit "#formatted_ivi_revenue_price" do
        expect(@cookie.formatted_ivi_revenue_price).to eq("asdasdasdasd")
      end

      it "#formatted_created_at" do
        expect(@cookie.formatted_created_at).to eq("Wednesday, April 17, 2024")
      end
    end
  end
end
