require 'rails_helper'

RSpec.describe 'Merchant_items#index', type: :feature do
  before(:each) do
    @merchant = create(:merchant)
    @merchant2 = create(:merchant)

    @customer_list = create_list(:customer, 6)

    @item_list = create_list(:item, 21, merchant: @merchant)
    @item_list2 = create_list(:item, 21, merchant: @merchant, status: "disabled")

    @invoice_list = []
    @invoice_list << create(:invoice, customer: @customer_list[0], created_at: "2022-01-01 00:00:00")
    2.times { @invoice_list << create(:invoice, customer: @customer_list[1], created_at: "2021-01-01 00:00:00")}
    3.times { @invoice_list << create(:invoice, customer: @customer_list[2]) }
    4.times { @invoice_list << create(:invoice, customer: @customer_list[3]) }
    5.times { @invoice_list << create(:invoice, customer: @customer_list[4]) }
    6.times { @invoice_list << create(:invoice, customer: @customer_list[5]) }

    @invoice_item_list = []
    @item_list.each_with_index do |item, index|
      if index < 10
        @invoice_item_list << create(:invoice_item, item:,
                                                  invoice: @invoice_list[index], unit_price: item.unit_price, status: "packaged")
      elsif index < 15
        @invoice_item_list << create(:invoice_item, item:,
                                                  invoice: @invoice_list[index], unit_price: item.unit_price, status: "pending")
      else 
        @invoice_item_list << create(:invoice_item, item:,
                                                    invoice: @invoice_list[index], unit_price: item.unit_price, status: "shipped")
      end
    end
    @transaction_list = []
    @invoice_list.each_with_index do |invoice, index|
      @transaction_list << create(:transaction, invoice:)
    end
  end

  # User Story 6
  xit "list of all the names" do
  # As a merchant, when I visit my merchant items index page (merchants/:merchant_id/items)
  visit merchant_items_path(@merchant)
  # I see a list of the names of all of my items
  within '.name_of_items' do
    expect(page).to have_content(@item_list[0].name)
    expect(page).to have_content(@item_list[1].name)
    expect(page).to have_content(@item_list[2].name)
    expect(page).to have_content(@item_list[3].name)
    expect(page).to have_content(@item_list[4].name)
  end
  # And I do not see items for any other merchant
  within '.name_of_items' do
    expect(page).to have_content(@item_list2[0].name)
    expect(page).to have_content(@item_list2[1].name)
    expect(page).to have_content(@item_list2[2].name)
    expect(page).to have_content(@item_list2[3].name)
    expect(page).to have_content(@item_list2[4].name)
  end

  expect(page).to_not have_content(@item_list2[0].name) # We might need to fix - random data everytime, hard to eliminate certain items
  end

  # User Story 9
  it 'update item button' do
    # As a merchant, when I visit my items index page (/merchants/:merchant_id/items)
    visit merchant_items_path(@merchant)
    # Next to each item name I see a button to disable or enable that item.
    # save_and_open_page
    within "#disabled-#{@item_list2[5].id}" do
      expect(page).to_not have_button("Disable")
      expect(page).to have_button("Enable")
      click_button("Enable")
      # When I click this button
    end
    # Then I am redirected back to the items index
    expect(current_path).to eq(merchant_items_path(@merchant))
    # And I see that the items status has changed
  
    within "#enabled_#{@item_list[0].id}" do
      expect(page).to_not have_content("Enable")
      expect(page).to have_button("Disable")
      # When I click this button
      click_button("Disable")
    end
    expect(current_path).to eq(merchant_items_path(@merchant))
    # Then I am redirected back to the items index
  end

  # User Story 10
  it "Merchant Items status listed in the appropiate section" do
    # As a merchant, when I visit my merchant items index page
    visit merchant_items_path(@merchant)
    # Then I see two sections, one for "Enabled Items" and one for "Disabled Items"
    # And I see that each Item is listed in the appropriate section
    within '.disabled_items' do
      expect(page).to have_content("Disabled Items:")
      expect(page).to have_link(@item_list2[0].name)
    end
    
    within '.enabled_items' do
      expect(page).to have_content("Enabled Items:")
      expect(page).to have_link(@item_list[0].name)
    end
  end

  # User Story 11
  it 'has a create new item link' do
    # As a merchant, when I visit my items index page
    visit merchant_items_path(@merchant)
    # I see a link to create a new item.
    expect(page).to have_link("New Item")

    # When I click on the link,
    click_link("New Item")

    # I am taken to a form that allows me to add item information.
    expect(current_path).to eq("/merchant/#{@merchant.id}/items/new")

    # When I fill out the form I click ‘Submit’
    fill_in :name, with: "Cookies"
    fill_in :description, with: "Cookies"
    fill_in :unit_price, with: 1100
    click_button "Create Item"

    # Then I am taken back to the items index page
    expect(current_path).to eq("/merchant/#{@merchant.id}/items")
    
    # And I see the item I just created displayed in the list of items.
    # And I see my item was created with a default status of disabled.
    within '.disabled_items' do
      expect(page).to have_content("Cookies")
    end
  end

  # User Story 12
  it 'has top 5 selling items for that merchant' do
    # As a merchant, when I visit my items index page
    visit merchant_items_path(@merchant)
    save_and_open_page
    # Then I see the names of the top 5 most popular items ranked by total revenue generated
    # And I see that each item name links to my merchant item show page for that item
    # And I see the total revenue generated next to each item name    
    within '.top_5_items' do
      expect(@merchant.top_five_items[0].name).to appear_before(@merchant.top_five_items[1].name)
      expect(@merchant.top_five_items[0].formatted_ivi_revenue_price).to appear_before(@merchant.top_five_items[1].formatted_ivi_revenue_price)
      expect(page).to have_link(@merchant.top_five_items[0].name)
      expect(@merchant.top_five_items[1].name).to appear_before(@merchant.top_five_items[2].name)
      expect(@merchant.top_five_items[1].formatted_ivi_revenue_price).to appear_before(@merchant.top_five_items[2].formatted_ivi_revenue_price)
      expect(page).to have_link(@merchant.top_five_items[1].name)
      expect(@merchant.top_five_items[2].name).to appear_before(@merchant.top_five_items[3].name)
      expect(@merchant.top_five_items[2].formatted_ivi_revenue_price).to appear_before(@merchant.top_five_items[3].formatted_ivi_revenue_price)
      expect(page).to have_link(@merchant.top_five_items[2].name)
      expect(@merchant.top_five_items[3].name).to appear_before(@merchant.top_five_items[4].name)
      expect(@merchant.top_five_items[3].formatted_ivi_revenue_price).to appear_before(@merchant.top_five_items[4].formatted_ivi_revenue_price)
      expect(page).to have_link(@merchant.top_five_items[3].name)
      expect(page).to have_link(@merchant.top_five_items[4].name)
    end
    # Notes on Revenue Calculation:
    # - Only invoices with at least one successful transaction should count towards revenue
    # - Revenue for an invoice should be calculated as the sum of the revenue of all invoice items
    # - Revenue for an invoice item should be calculated as the invoice item unit price multiplied by the quantity (do not use the item unit price)
  end


end