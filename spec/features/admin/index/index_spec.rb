require("rails_helper")

RSpec.describe "Admin dashboard" do
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
end
