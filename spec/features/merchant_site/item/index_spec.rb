require "rails_helper"

RSpec.describe "Merchant_items#index", type: :feature do
  before(:each) do
    define_instance_variables
  end

  # User Story 6
  it "list of all the names" do
    visit merchant_items_path(@merchant)

    expect(page).to have_content(@item_list[0].name)
    expect(page).to have_content(@item_list[1].name)
    expect(page).to have_content(@item_list[2].name)
    expect(page).to have_content(@item_list[3].name)
    expect(page).to have_content(@item_list[4].name)

    expect(page).to have_content(@item_list2[0].name)
    expect(page).to have_content(@item_list2[1].name)
    expect(page).to have_content(@item_list2[2].name)
    expect(page).to have_content(@item_list2[3].name)
    expect(page).to have_content(@item_list2[4].name)
  end

  # User Story 7
  it "merchant item show page lists name, description, and selling price" do
    visit merchant_items_path(@merchant)

    within ".top_5_items" do
      click_link @item_list[0].name
    end
    expect(current_path).to eq(merchant_item_path(@merchant, @item_list[0]))

    within ".item_attributes" do
      expect(page).to have_content(@item_list[0].name)
      expect(page).to have_content("Description: #{@item_list[0].description}")
      expect(page).to have_content(
        "Current Selling Price: #{@item_list[0].formatted_unit_price}"
      )
    end
  end

  # User Story 9
  it "update item button" do
    visit merchant_items_path(@merchant)

    within "#disabled-#{@item_list2[0].id}" do
      expect(page).to_not have_button("Disable")
      expect(page).to have_button("Enable")
      click_button("Enable")
    end

    expect(current_path).to eq(merchant_items_path(@merchant))

    within "#enabled_#{@item_list2[0].id}" do
      expect(page).to_not have_content("Enable")
      expect(page).to have_button("Disable")
      click_button("Disable")
    end

    expect(current_path).to eq(merchant_items_path(@merchant))
  end

  # User Story 10
  it "Merchant Items status listed in the appropiate section" do
    visit merchant_items_path(@merchant)

    within ".disabled_items" do
      expect(page).to have_content("Disabled Items:")
      expect(page).to have_link(@item_list2[0].name)
    end

    within ".enabled_items" do
      expect(page).to have_content("Enabled Items:")
      expect(page).to have_link(@item_list[0].name)
    end
  end

  # User Story 11
  it "has a create new item link" do
    visit merchant_items_path(@merchant)

    expect(page).to have_link("New Item")

    click_link("New Item")
    expect(current_path).to eq("/merchant/#{@merchant.id}/items/new")

    fill_in :name, with: "Cookies"
    fill_in :description, with: "Cookies"
    fill_in :unit_price, with: 1100
    click_button "Create Item"

    expect(current_path).to eq("/merchant/#{@merchant.id}/items")

    within ".disabled_items" do
      expect(page).to have_content("Cookies")
    end
  end

  # User Story 12
  it "has top 5 selling items for that merchant" do
    visit merchant_items_path(@merchant)

    within ".top_5_items" do
      expect(@merchant.top_five_items[0].name).to appear_before(@merchant.top_five_items[1].name)
      expect(page).to have_link(@merchant.top_five_items[0].name)

      expect(@merchant.top_five_items[1].name).to appear_before(@merchant.top_five_items[2].name)
      expect(page).to have_link(@merchant.top_five_items[1].name)

      expect(@merchant.top_five_items[2].name).to appear_before(@merchant.top_five_items[3].name)
      expect(page).to have_link(@merchant.top_five_items[2].name)

      expect(@merchant.top_five_items[3].name).to appear_before(@merchant.top_five_items[4].name)
      expect(page).to have_link(@merchant.top_five_items[3].name)

      expect(page).to have_link(@merchant.top_five_items[4].name)
    end
  end
end
