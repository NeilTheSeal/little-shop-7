require("rails_helper")

RSpec.describe Item do
  describe "instance methods" do
    it "#formatted_unit_price" do
      @merchant = Merchant.create!(name: "Sally's Bakery")
      @cookie = Item.create!(
        name: "Cookie",
        description: "It's a good cookie.",
        unit_price: 251,
        merchant_id: @merchant.id
      )
      expect(@cookie.formatted_unit_price).to eq("$2.51")
    end
  end
end
