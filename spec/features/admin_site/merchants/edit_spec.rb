require("rails_helper")

RSpec.describe "Merchant edit page" do
  before(:each) do
    @merchant = create(:merchant)
  end

  it "has a form to edit merchant info" do
    visit "/admin/merchants/#{@merchant.id}/edit"

    expect(page).to have_content("Edit information for #{@merchant.name}")
    expect(page).to have_css("form")
    expect(page).to have_field("name")
    expect(find('input[name="name"]').value).to eq(@merchant.name)
  end

  it "can update the merchant info" do
    visit "/admin/merchants/#{@merchant.id}/edit"

    fill_in("name", with: "")
    click_button("update")

    expect(page).to have_current_path("/admin/merchants/#{@merchant.id}/edit")
    expect(page).to have_content("You did not provide a valid name for this merchant.")

    fill_in("name", with: "John Doe")
    click_button("update")

    expect(page).to have_current_path("/admin/merchants/#{@merchant.id}")
    expect(page).to have_content("John Doe")
    expect(page).to have_content("You have successfully updated this merchant's information.")
  end
end
