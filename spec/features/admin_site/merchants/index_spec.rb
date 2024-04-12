require("rails_helper")

RSpec.describe "Merchant dashboard" do
  before(:each) do
    @merchants_list = create_list(:merchant, 3)
  end

  it "shows the name of each merchant in the system" do
    visit "/admin/merchants"

    expect(page).to have_content(@merchants_list[0].name)
    expect(page).to have_content(@merchants_list[1].name)
    expect(page).to have_content(@merchants_list[2].name)
  end
end
