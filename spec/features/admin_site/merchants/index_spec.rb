require("rails_helper")

RSpec.describe "Merchant dashboard" do
  before(:each) do
    @merchants_list = create_list(:merchant, 3)
  end

  it "shows the name of each merchant in the system and their status" do
    visit "/admin/merchants"

    expect(page).to have_content(@merchants_list[0].name)
    expect(page).to have_content(@merchants_list[1].name)
    expect(page).to have_content(@merchants_list[2].name)
    expect(page).to have_content("Status: Enabled")
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
      expect(page).to have_button("enable")
      expect(page).to have_button("disable")
      click_button("disable")
    end

    expect(page).to have_current_path("/admin/merchants")

    within "#merchant-#{@merchants_list[0].id}" do
      expect(page).to have_content("Status: Disabled")
      click_button("enable")
    end

    expect(page).to have_current_path("/admin/merchants")

    within "#merchant-#{@merchants_list[0].id}" do
      expect(page).to have_content("Status: Enabled")
    end
  end
end
