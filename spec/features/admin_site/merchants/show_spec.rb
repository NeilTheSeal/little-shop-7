require("rails_helper")

RSpec.describe "Merchant show page" do
  before(:each) do
    @merchant = create(:merchant)
  end

  it "has a link to update merchant info" do
    visit "/admin/merchants/#{@merchant.id}"

    click_link("update")

    expect(page).to have_current_path("/admin/merchants/#{@merchant.id}/edit")
  end

  it "does not show flash message before merchant info has been updated" do
    visit "/admin/merchants/#{@merchant.id}"

    expect(page).to_not have_content(
      "You have successfully updated this merchant's information."
    )
  end
end
