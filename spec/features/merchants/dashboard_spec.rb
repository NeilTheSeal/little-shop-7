require 'rails_helper'

RSpec.describe 'merchant dashboard', type: :feature do
  before(:each) do
    @merchant = create(:merchant)
  end

  # 1. Merchant Dashboard
  it "merchant dashboard" do
    # As a merchant,
    # When I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
    # visit "/merchants/#{@merchant.id}/dashboard"
    visit dashboard_merchant_path(@merchant)
    # save_and_open_page
    # Then I see the name of my merchant
    expect(page).to have_content(@merchant.name)
  end

  # 2. Merchant Dashboard Links
  it "" do
    # As a merchant,
    # When I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
    visit dashboard_merchant_path(@merchant)
    # Then I see link to my merchant items index (/merchants/:merchant_id/items)
    within '.merchant_items' do
      expect(page).to have_link("Merchant")
      click_link()
      expect(current_path).to eq()
    end
    # And I see a link to my merchant invoices index (/merchants/:merchant_id/invoices)
    within '.' do
      
    end
  end
end