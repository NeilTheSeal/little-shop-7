require("rails_helper")

RSpec.describe "Merchant dashboard" do
  before(:each) do
    @merchants_list = create_list(:merchant, 3)
    @disabled_merchant = create(:merchant, status: 1)
  end

  it "shows the name of each merchant in the system and their status" do
    visit "/admin/merchants"

    expect(page).to have_content(@merchants_list[0].name)
    expect(page).to have_content(@merchants_list[1].name)
    expect(page).to have_content(@merchants_list[2].name)
  end

  it "has a link to each merchant's show page" do
    visit "/admin/merchants"

    expect(page).to have_link(@merchants_list[0].name)

    click_link(@merchants_list[0].name)

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
end
