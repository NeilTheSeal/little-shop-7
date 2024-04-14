require("rails_helper")

RSpec.describe "Create new merchant" do
  it "has a form to add a new merchant" do
    visit "/admin/merchants/new"

    # Question - check whether it is okay to use find_css for finding elements
    expect(page).to have_css("form")
    within(find("form")) do
      expect(page).to have_field("name")
      expect(page).to have_css('input[type="submit"]')
    end
  end

  it "can create a new merchant" do
    visit "/admin/merchants/new"

    fill_in("name", with: "Stonks Corp")
    click_button("create")

    expect(page).to have_current_path("/admin/merchants")

    # within("#merchant-#{}")
  end
end
