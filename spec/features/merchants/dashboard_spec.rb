require 'rails_helper'

RSpec.describe 'merchant dashboard', type: :feature do
  before(:each) do
    @merchant = create(:merchant)
  end

  # User Story 1
  it "merchant dashboard has the merchant's name" do
    # As a merchant, when I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
    visit dashboard_merchant_path(@merchant)

    # I see the name of my merchant
    expect(page).to have_content(@merchant.name)
  end

  # User Story 2
  it "merchant dashboard has links to merchant items and invoices" do
    # As a merchant, when I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
    visit dashboard_merchant_path(@merchant)

    # I see link to my merchant items index (/merchants/:merchant_id/items)
    within '.merchant_items' do
      expect(page).to have_link("Merchant Items")
      click_link("Merchant Items")
      expect(current_path).to eq(merchant_items_path(@merchant))
    end

    visit dashboard_merchant_path(@merchant)
    
    # And I see a link to my merchant invoices index (/merchants/:merchant_id/invoices)
    within '.merchant_invoices' do
      expect(page).to have_link("Merchant Invoices")
      click_link("Merchant Invoices")
      expect(current_path).to eq(merchant_invoices_path(@merchant))
    end
  end

  # User Story 3
  it 'merchant dashboard shows top 5 customers, with number of successful transactions' do
    # As a merchant, when I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
    visit dashboard_merchant_path(@merchant)
    save_and_open_page

    # Then I see the names of the top 5 customers who have conducted the largest number of successful transactions with my merchant
    within '.merchant_top_5_customers' do
      # And next to each customer name I see the number of successful transactions they have conducted with my merchant
    end
  end
  
  # User Story 4
  it 'merchant dashboard has list of names of items that have been ordered but not shipped' do
    # As a merchant, when I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
    visit dashboard_merchant_path(@merchant)

    # Then I see a section for "Items Ready to Ship"
    within ".merchant_items_to_be_shipped" do
      expect(page).to have_content ("Items Ready to Ship")
      # In that section I see a list of the names of all of my items that have been ordered and have not yet been shipped,
      # And next to each Item I see the id of the invoice that ordered my item
      # And each invoice id is a link to my merchant's invoice show page
    end
  end

  # User Story 5
  it 'merchant dashboard has invoices for ordered items with date, sorted from oldest to newest' do
    # As a merchant, when I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
    visit dashboard_merchant_path(@merchant)

    # In the section for "Items Ready to Ship",
    within ".merchant_items_to_be_shipped" do
      expect(page).to have_content ("Items Ready to Ship")
      # Next to each Item name I see the date that the invoice was created
      # And I see the date formatted like "Monday, July 18, 2019"
      # And I see that the list is ordered from oldest to newest      
    end
  end

end