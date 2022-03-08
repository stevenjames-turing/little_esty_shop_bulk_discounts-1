require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end

  before(:each) do 
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item_2 = Item.create!(name: "Hair Dye", description: "This colors your hair", unit_price: 25, merchant_id: @merchant1.id, status: 1)
    @item_3 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 25, status: 1)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_3.id, quantity: 4, unit_price: 10, status: 1)
    @bd1 = BulkDiscount.create!(discount: 0.25, threshold: 7, merchant: @merchant1)
    @bd2 = BulkDiscount.create!(discount: 0.20, threshold: 4, merchant: @merchant1)
    @bd3 = BulkDiscount.create!(discount: 0.15, threshold: 2, merchant: @merchant1)
  end
  describe 'instance methods' do
    describe '.total_revenue' do 
      it 'calculates total revenue for an invoice without bulk discounts' do
        expect(@invoice_1.total_revenue).to eq(155)
      end
    end
    describe '.discounted_revenue' do 
      it 'calculates total revenue for an invoice including invoice_items that have been discounted' do 
        expect(@invoice_1.discounted_revenue).to eq(124.5)
      end
    end
  end
end
