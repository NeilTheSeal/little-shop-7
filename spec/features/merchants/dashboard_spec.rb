require 'rails_helper'

RSpec.describe 'merchant dashboard', type: :feature do
  before(:each) do
    @merchant = create(:merchant)
  end

  # User Story 1
  it "merchant dashboard" do
    # As a merchant, when I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
    visit dashboard_merchant_path(@merchant)

    # I see the name of my merchant
    expect(page).to have_content(@merchant.name)
  end

  # User Story 2
  it "has links to merchant items and invoices" do
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
end