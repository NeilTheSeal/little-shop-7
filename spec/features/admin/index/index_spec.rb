require("rails_helper")

RSpec.describe "Admin dashboard" do
  before(:each) do
    @customers = create_list(:customer, 5)
    @merchant = create(:merchant)

    @item_list1 = create_list(:item, 3, merchant: @merchant, unit_price: 1000)
    @item_list2 = create_list(:item, 3, merchant: @merchant, unit_price: 1000)
    @item_list3 = create_list(:item, 3, merchant: @merchant, unit_price: 1000)


    @customer1_invoice_list = create_list(:invoice, 1, customer: @customers[0])
    @customer2_invoice_list = create_list(:invoice, 3, customer: @customers[1])
    @customer3_invoice_list = create_list(:invoice, 5, customer: @customers[2])
    @customer4_invoice_list = create_list(:invoice, 4, customer: @customers[3])
    @customer5_invoice_list = create_list(:invoice, 2, customer: @customers[4])

    @invoice_item1 = create(:invoice_item, item: @item_list1[0], invoice: @customer1_invoice_list[0], unit_price: @item_list1[0].unit_price, status: "shipped")
    @invoice_item2 = create(:invoice_item, item: @item_list1[1], invoice: @customer1_invoice_list[0], unit_price: @item_list1[1].unit_price, status: "shipped")
    @invoice_item3 = create(:invoice_item, item: @item_list1[2], invoice: @customer1_invoice_list[0], unit_price: @item_list1[2].unit_price, status: "shipped")
    @invoice_item4 = create(:invoice_item, item: @item_list2[0], invoice: @customer2_invoice_list[0], unit_price: @item_list2[0].unit_price, status: "shipped")
    @invoice_item5 = create(:invoice_item, item: @item_list2[1], invoice: @customer2_invoice_list[0], unit_price: @item_list2[1].unit_price, status: "pending")
    @invoice_item6 = create(:invoice_item, item: @item_list2[2], invoice: @customer2_invoice_list[0], unit_price: @item_list2[2].unit_price, status: "packaged")
    @invoice_item7 = create(:invoice_item, item: @item_list3[0], invoice: @customer3_invoice_list[0], unit_price: @item_list3[0].unit_price, status: "pending")
    @invoice_item8 = create(:invoice_item, item: @item_list3[1], invoice: @customer3_invoice_list[0], unit_price: @item_list3[1].unit_price, status: "packaged")
    @invoice_item9 = create(:invoice_item, item: @item_list3[2], invoice: @customer3_invoice_list[0], unit_price: @item_list3[2].unit_price, status: "packaged")

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

  it "shows a list of all invoices that have items that have not yet been shipped" do
    visit "/admin"

    expect(page).to have_content("Incomplete Invoices")

    expect(page).to have_content(@customer2_invoice_list[0].id)
    expect(page).to have_content(@customer3_invoice_list[0].id)
    expect(page).to_not have_content(@customer1_invoice_list[0].id)
  end

  it "has each invoice id which links to that invoice's admin show page" do
    visit "/admin"

    click_link("Invoice ##{@customer2_invoice_list[0].id}")
    expect(page).to have_current_path("/admin/invoices/#{@customer2_invoice_list[0].id}")
  end
end
