require("rails_helper")

RSpec.describe Customer do
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

  describe "associations" do
    it { should have_many :invoices }
    it { should have_many(:invoice_items).through(:invoices) }
  end

  it "should list the top 5 customers in descending order" do
    expect(Customer.top_customers).to eq([
      @customers[2],
      @customers[3],
      @customers[1],
      @customers[4],
      @customers[0]
    ])
  end
end
