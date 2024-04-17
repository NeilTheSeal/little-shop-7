require "rails_helper"

RSpec.describe "Merchant_items#show", type: :feature do
  before(:each) do
    define_instance_variables
  end

  # User Story 7
  it "merchant item show page lists name, description, and selling price" do
    visit merchant_items_path(@merchant)

    click_link @item_list[0].name
    expect(current_path).to eq(merchant_item_path(@merchant, @item_list[0]))

    within ".item_attributes" do
      expect(page).to have_content(@item_list[0].name)
      expect(page).to have_content("Description: #{@item_list[0].description}")
      expect(page).to have_content(
        "Current Selling Price: #{@item_list[0].formatted_unit_price}"
      )
    end
  end

  # User Story 8
  it "update item button" do
    visit merchant_item_path(@merchant, @item_list[0])

    expect(page).to have_link("Update Item")

    click_link "Update Item"
    expect(current_path).to eq(
      edit_merchant_item_path(@merchant, @item_list[0])
    )

    fill_in "Item Name:", with: "Spaghetti"
    fill_in "Item Description:", with: "I like pasta"
    fill_in "Item Selling Price (in cents):", with: "1100"

    click_button "Update Item"
    expect(current_path).to eq(
      merchant_item_path(@merchant, @item_list[0])
    )

    expect(page).to have_content("Spaghetti")
    expect(page).to have_content("I like pasta")
    expect(page).to have_content("$11.0")
  end
end
