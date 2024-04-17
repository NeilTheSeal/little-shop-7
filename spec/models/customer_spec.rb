require("rails_helper")

RSpec.describe Customer do
  describe "model relationships" do
    it { should have_many(:invoices) }
    it { should have_many(:invoice_items).through(:invoices) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:merchants).through(:items) }
  end

  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end

  before(:each) do
    @customers = create_list(:customer, 5)
    @merchant = create(:merchant)
    @item = create(:item, merchant: @merchant, unit_price: 1000)

    @customer1_invoice_list = create_list(:invoice, 1, customer: @customers[0])
    @customer2_invoice_list = create_list(:invoice, 3, customer: @customers[1])
    @customer3_invoice_list = create_list(:invoice, 5, customer: @customers[2])
    @customer4_invoice_list = create_list(:invoice, 4, customer: @customers[3])
    @customer5_invoice_list = create_list(:invoice, 2, customer: @customers[4])

    @customer1_invoice_list.each do |invoice|
      create(:transaction, invoice:)
      create(
        :invoice_item,
        item: @item,
        invoice:,
        unit_price: @item.unit_price,
        quantity: 1
      )
    end
    @customer2_invoice_list.each do |invoice|
      create(:transaction, invoice:)
      create(
        :invoice_item,
        item: @item,
        invoice:,
        unit_price: @item.unit_price,
        quantity: 1
      )
    end
    @customer3_invoice_list.each do |invoice|
      create(:transaction, invoice:)
      create(
        :invoice_item,
        item: @item,
        invoice:,
        unit_price: @item.unit_price,
        quantity: 1
      )
    end
    @customer4_invoice_list.each do |invoice|
      create(:transaction, invoice:)
      create(
        :invoice_item,
        item: @item,
        invoice:,
        unit_price: @item.unit_price,
        quantity: 1
      )
    end
    @customer5_invoice_list.each do |invoice|
      create(:transaction, invoice:)
      create(
        :invoice_item,
        item: @item,
        invoice:,
        unit_price: @item.unit_price,
        quantity: 1
      )
    end
  end

  describe "class methods" do
    it "#top_customers" do
      expect(Customer.top_customers).to eq([
        @customers[2], @customers[3], @customers[1], @customers[4], @customers[0]
      ])
    end
  end
end
