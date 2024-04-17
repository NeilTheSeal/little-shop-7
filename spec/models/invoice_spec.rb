require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "model relationships" do
    it { should belong_to(:customer) }
    it { should have_many(:invoice_items) }
    it { should have_many(:transactions) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
  end

  describe 'class methods' do
    xit 'unshipped_invoices' do
    end
  end

  describe 'instance methods' do
    xit 'total_revenue' do
    end
  end
end