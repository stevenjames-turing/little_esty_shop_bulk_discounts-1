require 'rails_helper'

RSpec.describe 'merchant bulk discount index' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Arch City Apparel')

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    @bd1 = BulkDiscount.create!(discount: 0.20, threshold: 20, merchant_id: @merchant1.id)
    @bd2 = BulkDiscount.create!(discount: 0.10, threshold: 5, merchant_id: @merchant1.id)
    @bd3 = BulkDiscount.create!(discount: 0.25, threshold: 30, merchant_id: @merchant1.id)
    @bd4 = BulkDiscount.create!(discount: 0.15, threshold: 10, merchant_id: @merchant2.id)

    visit merchant_bulk_discounts_path(@merchant1)
  end

  it 'includes merchant name' do 
    expect(page).to have_content(@merchant1.name)
  end

  it 'displays all bulk discounts percentage' do 
    within ("#bulk-discounts") do 
      expect(page).to have_content((@bd1.discount * 100).round)
      expect(page).to have_content((@bd2.discount * 100).round)
      expect(page).to have_content((@bd3.discount * 100).round)
      expect(page).to_not have_content((@bd4.discount * 100).round)
    end
  end
  
  it 'displays all bulk discounts thresholds' do 
    within ("#bulk-discounts") do 
      expect(page).to have_content(@bd1.threshold)
      expect(page).to have_content(@bd2.threshold)
      expect(page).to have_content(@bd3.threshold)
      expect(page).to_not have_content("#{@bd4.threshold} items or more")
    end
  end
  
  it 'includes a link to the bulk discount show page' do 
    within ("#bulk-discounts") do 
      expect(page).to have_link("View Discount", count: 3)
    end
  end
  
  it 'has an upcoming holidays header' do 
    expect(page).to have_content("Upcoming Holidays")
  end
  
  it 'has the name of the next 3 upcoming holidays' do 
    api = HolidayApi.new
    upcoming_holidays = api.upcoming_holidays(3)
    expect(page).to have_content(upcoming_holidays[0][:name])
    expect(page).to have_content(upcoming_holidays[1][:name])
    expect(page).to have_content(upcoming_holidays[2][:name])
  end
  
  it 'has the date of the next 3 upcoming holidays' do 
    api = HolidayApi.new
    upcoming_holidays = api.upcoming_holidays(3)
    expect(page).to have_content(upcoming_holidays[0][:date])
    expect(page).to have_content(upcoming_holidays[1][:date])
    expect(page).to have_content(upcoming_holidays[2][:date])
  end
  
  describe 'Merchant Bulk Discount Create' do 
    it 'has link to create a new discount' do 
      expect(page).to have_link("Create New Discount")
    end
    it 'displays new discount after creation' do 
      expect(page).to_not have_content("21% off 21 items or more")
      click_link "Create New Discount"
      expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/new")
      
      fill_in "Discount", with: 0.21
      fill_in "Threshold", with: 21
      click_button "Submit"
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
      
      expect(page).to have_content("21% off 21 items or more")
    end
  end
  
  describe 'Merchant Bulk Discount Delete' do
    it 'has a link to delete next to each discount' do
      expect(page).to have_button("Delete Discount", count: 3)
    end

    it 'deleted discount is removed from the index' do
      within ("#bulk-discounts") do 
        expect(page).to have_content((@bd1.discount * 100).round)
        expect(page).to have_content((@bd2.discount * 100).round)
        expect(page).to have_content((@bd3.discount * 100).round)
        expect(page).to_not have_content((@bd4.discount * 100).round)
      end

      within ("#discount-#{@bd1.id}") do 
        click_button "Delete Discount"
      end
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
      
      within ("#bulk-discounts") do 
        expect(page).to have_content((@bd2.discount * 100).round)
        expect(page).to have_content((@bd3.discount * 100).round)
        expect(page).to_not have_content((@bd1.discount * 100).round)
        expect(page).to_not have_content((@bd4.discount * 100).round)
      end
    end
  end

  describe 'holiday discounts' do 
    it 'has a Create Discount button next to each holiday' do
      within '#holidays' do
        expect(page).to have_button("Create Holiday Discount", count: 3)
      end 
    end
    it 'clicking button takes me to new form with holiday discount info pre-filled' do 
      api = HolidayApi.new
      holiday1 = api.upcoming_holidays(1)[0]

      first(:button, "Create Holiday Discount").click
      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
      expect(page).to have_field(:name, with: "#{holiday1[:name]} Discount")    
      expect(page).to have_field(:discount, with: 0.30)    
      expect(page).to have_field(:threshold, with: 2)      
    end
    it 'can leave the information as is for submittion' do 
      api = HolidayApi.new
      holiday1 = api.upcoming_holidays(1)[0]
      first(:button, "Create Holiday Discount").click
      expect(page).to have_field(:name, with: "#{holiday1[:name]} Discount")    
      expect(page).to have_field(:discount, with: 0.30)    
      expect(page).to have_field(:threshold, with: 2)
      click_button "Submit"

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))

      expect(page).to have_content("#{holiday1[:name]} Discount: 30% off 2 items or more")
    end
    it 'can change the pre-filled info before submittion' do 
      api = HolidayApi.new
      holiday1 = api.upcoming_holidays(1)[0]
      first(:button, "Create Holiday Discount").click
      fill_in "Discount", with: 0.21
      fill_in "Threshold", with: 12
      click_button "Submit"

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))

      expect(page).to have_content("#{holiday1[:name]} Discount: 21% off 12 items or more")
    end
  end
end 