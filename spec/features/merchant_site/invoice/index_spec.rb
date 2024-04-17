require "rails_helper"

RSpec.describe "merchant_invoices#index", type: :feature do
  before(:each) do
    define_instance_variables
  end

  # User Story 14
  it "merchant invoices link to its show page" do
    visit merchant_invoices_path(@merchant)

    within ".merchant_invoices" do
      within "#invoice-#{@invoice_list[0].id}" do
        expect(page).to have_link(@invoice_list[0].id)
      end

      within "#invoice-#{@invoice_list[1].id}" do
        expect(page).to have_link(@invoice_list[1].id)
        click_link(@invoice_list[1].id)
      end

      expect(current_path).to eq(
        merchant_invoice_path(@merchant, @invoice_list[1])
      )
    end
  end
end
