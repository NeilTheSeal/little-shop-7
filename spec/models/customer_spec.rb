require("rails_helper")

RSpec.describe Customer do
  describe "model relationships" do
    it { should have_many(:invoices) }
    it { should have_many(:invoice_items).through(:invoices) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:merchants).through(:items) }
  end

  before(:each) do
    @customers = create_list(:customer, 5)

    @customer1_invoice_list = create_list(:invoice, 1, customer: @customers[0])
    @customer2_invoice_list = create_list(:invoice, 3, customer: @customers[1])
    @customer3_invoice_list = create_list(:invoice, 5, customer: @customers[2])
    @customer4_invoice_list = create_list(:invoice, 4, customer: @customers[3])
    @customer5_invoice_list = create_list(:invoice, 2, customer: @customers[4])

    @customer1_invoice_list.each { |invoice| create(:transaction, invoice:) }
    @customer2_invoice_list.each { |invoice| create(:transaction, invoice:) }
    @customer3_invoice_list.each { |invoice| create(:transaction, invoice:) }
    @customer4_invoice_list.each { |invoice| create(:transaction, invoice:) }
    @customer5_invoice_list.each { |invoice| create(:transaction, invoice:) }
  end

  describe "class methods" do
    xit "#top_customers" do
      expect(Customer.top_customers).to eq("asdasd")
    end
  end
end
