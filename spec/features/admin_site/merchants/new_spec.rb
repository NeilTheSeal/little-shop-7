require("rails_helper")

RSpec.describe "Create new merchant" do
  it "has a form to add a new merchant" do
    visit "/admin/merchants/new"

    within("form") do
      expect(page).to have_field("name")
      expect(page).to have_css('input[type="submit"]')
    end
  end

  it "can create a new merchant" do
    visit "/admin/merchants/new"

    fill_in("name", with: "")
    click_button("create")

    expect(page).to have_current_path("/admin/merchants/new")
    expect(page).to have_content("Error: ")

    fill_in("name", with: "Stonks Corp")
    click_button("create")

    expect(page).to have_current_path("/admin/merchants")

    within("#disabled-merchants") do
      expect(page).to have_content("Stonks Corp")
    end
  end
end
