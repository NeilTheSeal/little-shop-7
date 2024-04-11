require("rails_helper")

RSpec.describe "Admin dashboard" do
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

  it "has a header indicating it is the dashboard" do
    visit("/admin")
    expect(page).to have_content("Admin Dashboard")
  end

  it "has a link to the admin merchants index" do
    visit("/admin")
    expect(page).to have_link("merchants")
    click_link("merchants")
    expect(page).to have_current_path("/admin/merchants")
  end

  it "has a link to the admin invoices index" do
    visit("/admin")
    expect(page).to have_link("invoices")
    click_link("invoices")
    expect(page).to have_current_path("/admin/invoices")
  end

  it "lists the customer names in order of number of transactions" do
    visit("/admin")
    expect(@customers[2].first_name).to appear_before(@customers[3].first_name)
    expect(@customers[3].first_name).to appear_before(@customers[1].first_name)
    expect(@customers[1].first_name).to appear_before(@customers[4].first_name)
    expect(@customers[4].first_name).to appear_before(@customers[0].first_name)
    expect(@customers[2].last_name).to appear_before(@customers[3].last_name)
    expect(@customers[3].last_name).to appear_before(@customers[1].last_name)
    expect(@customers[1].last_name).to appear_before(@customers[4].last_name)
    expect(@customers[4].last_name).to appear_before(@customers[0].last_name)
  end
end
