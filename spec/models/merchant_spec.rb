require "rails_helper"

RSpec.describe Merchant, type: :model do
  describe "model relationships" do
    it { should have_many(:items) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe "instance methods" do
    before(:each) do
      @merchant = create(:merchant)

      @customer_list = create_list(:customer, 6)

      @item_list = create_list(:item, 21, merchant: @merchant)

      @invoice_list = []
      @invoice_list << create(:invoice, customer: @customer_list[0])
      2.times { @invoice_list << create(:invoice, customer: @customer_list[1]) }
      3.times { @invoice_list << create(:invoice, customer: @customer_list[2]) }
      4.times { @invoice_list << create(:invoice, customer: @customer_list[3]) }
      5.times { @invoice_list << create(:invoice, customer: @customer_list[4]) }
      6.times { @invoice_list << create(:invoice, customer: @customer_list[5]) }

      @invoice_item_list = []
      @item_list.each_with_index do |item, index|
        @invoice_item_list << create(:invoice_item, item:,
                                                    invoice: @invoice_list[index], unit_price: item.unit_price)
      end
      @transaction_list = []
      @invoice_list.each_with_index do |invoice, index|
        @transaction_list << create(:transaction, invoice:)
      end
    end

    it "list the top 5 customers for each merchant" do
      top_five = @merchant.top_five_customers
      expect(top_five[0].customer_name).to eq(@customer_list[5].first_name.concat(" #{@customer_list[5].last_name}"))
      expect(top_five[1].customer_name).to eq(@customer_list[4].first_name.concat(" #{@customer_list[4].last_name}"))
      expect(top_five[2].customer_name).to eq(@customer_list[3].first_name.concat(" #{@customer_list[3].last_name}"))
      expect(top_five[3].customer_name).to eq(@customer_list[2].first_name.concat(" #{@customer_list[2].last_name}"))
      expect(top_five[4].customer_name).to eq(@customer_list[1].first_name.concat(" #{@customer_list[1].last_name}"))
    end

    it "#ready_to_ship_items" do
      expect(@merchant.ready_to_ship_items).to eq(@invoice_item_list)
    end

    it "#unique_invoices" do
      expect(@merchant.unique_invoices).to eq(@merchant.invoices.distinct)
    end

    xit "#top_five_items" do
      expect(@merchant.top_five_items).to eq(@item_list)
    end
  end

  describe "class methods" do
    before(:each) do
      @merchants_list = create_list(:merchant, 3)
      @disabled_merchant = create(:merchant, status: 1)
      @customers = create_list(:customer, 5)
      @merchants = create_list(:merchant, 6)
      @dummy_customer = create(:customer)
      @failure_customer = create(:customer)

      # merchants[0] = 3000
      # merchants[1] = 4000
      # merchants[2] = 5000
      # merchants[3] = 6000
      # merchants[4] = 7000
      # merchants[5] = 8000

      @item_list1 = create_list(
        :item,
        3,
        merchant: @merchants[0],
        unit_price: 1000
      )
      @item_list2 = create_list(
        :item,
        3,
        merchant: @merchants[1],
        unit_price: 1000
      )
      @item_list3 = create_list(
        :item,
        3,
        merchant: @merchants[2],
        unit_price: 1000
      )
      @item_list4 = create_list(
        :item,
        3,
        merchant: @merchants[3],
        unit_price: 1000
      )
      @item_list5 = create_list(
        :item,
        3,
        merchant: @merchants[4],
        unit_price: 1000
      )
      @item_list6 = create_list(
        :item,
        3,
        merchant: @merchants[5],
        unit_price: 1000
      )

      @customer1_invoice_list = create_list(
        :invoice,
        1,
        customer: @customers[0],
        created_at: "2020-01-01 00:00:00"
      )
      @customer2_invoice_list = create_list(
        :invoice,
        3,
        customer: @customers[1],
        created_at: "2022-01-01 00:00:00"
      )
      @customer3_invoice_list = create_list(
        :invoice,
        5,
        customer: @customers[2],
        created_at: "2021-01-01 00:00:00"
      )
      @customer4_invoice_list = create_list(
        :invoice,
        4,
        customer: @customers[3]
      )
      @customer5_invoice_list = create_list(
        :invoice,
        2,
        customer: @customers[4]
      )
      @dummy_invoice = create(:invoice, customer: @dummy_customer)
      @failure_invoice = create(:invoice, customer: @failure_customer)

      @invoice_item1 = create(
        :invoice_item,
        item: @item_list1[0],
        invoice: @customer1_invoice_list[0],
        unit_price: @item_list1[0].unit_price,
        quantity: 1,
        status: "shipped"
      )
      @invoice_item2 = create(
        :invoice_item,
        item: @item_list1[1],
        invoice: @customer1_invoice_list[0],
        unit_price: @item_list1[1].unit_price,
        quantity: 1,
        status: "shipped"
      )
      @invoice_item3 = create(
        :invoice_item,
        item: @item_list1[2],
        invoice: @customer1_invoice_list[0],
        unit_price: @item_list1[2].unit_price,
        quantity: 1,
        status: "shipped"
      )
      @invoice_item4 = create(
        :invoice_item,
        item: @item_list2[0],
        invoice: @customer2_invoice_list[0],
        unit_price: @item_list2[0].unit_price,
        quantity: 1,
        status: "shipped"
      )
      @invoice_item5 = create(
        :invoice_item,
        item: @item_list2[1],
        invoice: @customer2_invoice_list[0],
        unit_price: @item_list2[1].unit_price,
        quantity: 1,
        status: "pending"
      )
      @invoice_item6 = create(
        :invoice_item,
        item: @item_list2[2],
        invoice: @customer2_invoice_list[0],
        unit_price: @item_list2[2].unit_price,
        quantity: 2,
        status: "packaged"
      )
      @invoice_item7 = create(
        :invoice_item,
        item: @item_list3[0],
        invoice: @customer3_invoice_list[0],
        unit_price: @item_list3[0].unit_price,
        quantity: 1,
        status: "pending"
      )
      @invoice_item8 = create(
        :invoice_item,
        item: @item_list3[1],
        invoice: @customer3_invoice_list[0],
        unit_price: @item_list3[1].unit_price,
        quantity: 2,
        status: "packaged"
      )
      @invoice_item9 = create(
        :invoice_item,
        item: @item_list3[2],
        invoice: @customer3_invoice_list[0],
        unit_price: @item_list3[2].unit_price,
        quantity: 2,
        status: "packaged"
      )
      @invoice_item10 = create(
        :invoice_item,
        item: @item_list4[0],
        invoice: @dummy_invoice,
        unit_price: @item_list4[0].unit_price,
        quantity: 6,
        status: "packaged"
      )
      @invoice_item11 = create(
        :invoice_item,
        item: @item_list5[0],
        invoice: @dummy_invoice,
        unit_price: @item_list5[0].unit_price,
        quantity: 7,
        status: "packaged"
      )
      @invoice_item12 = create(
        :invoice_item,
        item: @item_list6[0],
        invoice: @dummy_invoice,
        unit_price: @item_list6[0].unit_price,
        quantity: 8,
        status: "packaged"
      )
      @invoice_item13 = create(
        :invoice_item,
        item: @item_list1[0],
        invoice: @failure_invoice,
        unit_price: @item_list1[0].unit_price,
        quantity: 100_000,
        status: "packaged"
      )

      @customer1_invoice_list.each { |invoice| create(:transaction, invoice:) }
      @customer2_invoice_list.each { |invoice| create(:transaction, invoice:) }
      @customer3_invoice_list.each { |invoice| create(:transaction, invoice:) }
      @customer4_invoice_list.each { |invoice| create(:transaction, invoice:) }
      @customer5_invoice_list.each { |invoice| create(:transaction, invoice:) }
      create(:transaction, invoice: @dummy_invoice, result: "failed")
      create(:transaction, invoice: @dummy_invoice, result: "success")
      create(:transaction, invoice: @failure_invoice, result: "failed")
    end

    it "can find the top 5 merchants" do
      expect(Merchant.top_five_merchants[0].merchant_name).to eq(@merchants[5].name)
      expect(Merchant.top_five_merchants[1].merchant_name).to eq(@merchants[4].name)
      expect(Merchant.top_five_merchants[2].merchant_name).to eq(@merchants[3].name)
      expect(Merchant.top_five_merchants[3].merchant_name).to eq(@merchants[2].name)
      expect(Merchant.top_five_merchants[4].merchant_name).to eq(@merchants[1].name)
      expect(Merchant.top_five_merchants[5].nil?).to eq(true)
    end
  end

  describe "date with most revenue" do
    it "shows the date with the most revenue made for each merchant" do
      merchant = create(:merchant)
      item = create(:item, merchant:, unit_price: 1000)
      customer = create(:customer)
      invoice1 = create(
        :invoice,
        customer:,
        created_at: "2020-01-01 00:00:00"
      )
      invoice2 = create(
        :invoice,
        customer:,
        created_at: "2021-01-01 00:00:00"
      )
      invoice3 = create(
        :invoice,
        customer:,
        created_at: "2022-01-01 00:00:00"
      )
      create(
        :invoice_item,
        item:,
        invoice: invoice1,
        quantity: 1,
        unit_price: item.unit_price
      )
      create(
        :invoice_item,
        item:,
        invoice: invoice2,
        quantity: 1,
        unit_price: item.unit_price
      )
      create(
        :invoice_item,
        item:,
        invoice: invoice2,
        quantity: 1,
        unit_price: item.unit_price
      )
      create(
        :invoice_item,
        item:,
        invoice: invoice3,
        quantity: 1,
        unit_price: item.unit_price
      )
      create(
        :invoice_item,
        item:,
        invoice: invoice3,
        quantity: 1,
        unit_price: item.unit_price
      )

      expect(merchant.date_of_most_revenue).to eq(
        "Saturday, January 01, 2022 at 12:00 AM"
      )
    end
  end
end
