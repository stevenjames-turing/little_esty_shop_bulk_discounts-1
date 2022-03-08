require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  before(:each) do
    @m1 = Merchant.create!(name: 'Merchant 1')
    @c1 = Customer.create!(first_name: 'Bilbo', last_name: 'Baggins')
    @c2 = Customer.create!(first_name: 'Frodo', last_name: 'Baggins')
    @c3 = Customer.create!(first_name: 'Samwise', last_name: 'Gamgee')
    @c4 = Customer.create!(first_name: 'Aragorn', last_name: 'Elessar')
    @c5 = Customer.create!(first_name: 'Arwen', last_name: 'Undomiel')
    @c6 = Customer.create!(first_name: 'Legolas', last_name: 'Greenleaf')
    @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: @m1.id)
    @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8, merchant_id: @m1.id)
    @item_3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5, merchant_id: @m1.id)
    @i1 = Invoice.create!(customer_id: @c1.id, status: 2)
    @i2 = Invoice.create!(customer_id: @c1.id, status: 2)
    @i3 = Invoice.create!(customer_id: @c2.id, status: 2)
    @i4 = Invoice.create!(customer_id: @c3.id, status: 2)
    @i5 = Invoice.create!(customer_id: @c4.id, status: 2)
    @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 3, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 4, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @i3.id, item_id: @item_3.id, quantity: 5, unit_price: 5, status: 1)
    @bd1 = BulkDiscount.create!(discount: 0.25, threshold: 5, merchant: @m1)
    @bd2 = BulkDiscount.create!(discount: 0.20, threshold: 4, merchant: @m1)
    @bd3 = BulkDiscount.create!(discount: 0.15, threshold: 3, merchant: @m1)
    @bd4 = BulkDiscount.create!(discount: 0.10, threshold: 2, merchant: @m1)
  end

  describe "class methods" do
    describe '#incomplete_invoices' do 
      it 'incomplete_invoices' do
        expect(InvoiceItem.incomplete_invoices).to eq([@i1, @i3])
      end
    end
  end
  describe 'instance methods' do 
    describe '.best_discount' do 
      it 'returns the best available bulk discount based on item quantity in invoice_item' do 
        expect(@ii_1.best_discount[0].id).to eq(@bd3.id)
        expect(@ii_2.best_discount[0].id).to eq(@bd2.id)
        expect(@ii_3.best_discount[0]).to eq(nil)
        expect(@ii_4.best_discount[0].id).to eq(@bd1.id)
      end
    end
  end
end
