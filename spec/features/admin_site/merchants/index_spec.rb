require("rails_helper")

RSpec.describe "Merchant dashboard" do
  describe "lists of merchants" do
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
        quantity: 100,
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

    it "shows the name of each merchant in the system and their status" do
      visit "/admin/merchants"

      expect(page).to have_content(@merchants_list[0].name)
      expect(page).to have_content(@merchants_list[1].name)
      expect(page).to have_content(@merchants_list[2].name)
    end

    it "has a link to each merchant's show page" do
      visit "/admin/merchants"

      within("#merchant-#{@merchants_list[0].id}") do
        expect(page).to have_link(@merchants_list[0].name)

        click_link(@merchants_list[0].name)
      end

      expect(page).to have_current_path("/admin/merchants/#{@merchants_list[0].id}")
    end

    it "has a button to enable or disable a merchant" do
      visit "/admin/merchants"

      within "#merchant-#{@merchants_list[0].id}" do
        expect(page).to have_button("disable")
        click_button("disable")
      end

      expect(page).to have_current_path("/admin/merchants")

      within "#merchant-#{@merchants_list[0].id}" do
        expect(page).to have_button("enable")
        click_button("enable")
      end

      expect(page).to have_current_path("/admin/merchants")

      within "#merchant-#{@merchants_list[0].id}" do
        expect(page).to have_button("disable")
      end
    end

    it "has a column for enabled merchants" do
      visit "/admin/merchants"

      within "#enabled-merchants" do
        expect(page).to have_content(@merchants_list[0].name)
      end

      within "#disabled-merchants" do
        expect(page).to have_content(@disabled_merchant.name)
      end
    end

    it "has a link to create a new merchant" do
      visit "/admin/merchants"

      click_link("New Merchant")

      expect(page).to have_current_path("/admin/merchants/new")
    end

    it "shows the top 5 merchants" do
      visit "/admin/merchants"
      save_and_open_page

      within "#top-merchants" do
        expect(@merchants[5].name).to appear_before(@merchants[4].name)
        expect(@merchants[4].name).to appear_before(@merchants[3].name)
        expect(@merchants[3].name).to appear_before(@merchants[2].name)
        expect(@merchants[2].name).to appear_before(@merchants[1].name)
        expect(page).to_not have_content(@merchants[0].name)
        expect(page).to have_content("Total sales: $80")
        expect(page).to have_content("Total sales: $70")
        expect(page).to have_content("Total sales: $60")
        expect(page).to have_content("Total sales: $50")
        expect(page).to have_content("Total sales: $40")
      end
    end

    it "has links to the show pages of the top 5 merchants" do
      visit "/admin/merchants"

      within "#top-merchants" do
        click_link(@merchants[5].name)
        expect(page).to have_current_path("/admin/merchants/#{@merchants[5].id}")
      end
    end
  end

  describe "top revenue days" do
    before(:each) do
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
      create(:transaction, invoice: invoice1)
      create(:transaction, invoice: invoice2)
      create(:transaction, invoice: invoice3)
    end

    it "lists the date of top revenue for each merchant" do
      visit "/admin/merchants"

      within "#top-merchants" do
        expect(page).to have_content(
          "Date with the highest revenue:   Saturday, January 01, 2022 at 12:00 AM"
        )
      end
    end
  end
end
