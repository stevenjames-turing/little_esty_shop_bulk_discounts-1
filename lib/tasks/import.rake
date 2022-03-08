require 'csv'

task :import, [:customers] => :environment do
  CSV.foreach('db/data/customers.csv', headers: true) do |row|
    Customer.create!(row.to_hash)
  end
  ActiveRecord::Base.connection.reset_pk_sequence!('customers')
end

task :import, [:merchants] => :environment do
  CSV.foreach('db/data/merchants.csv', headers: true) do |row|
    Merchant.create!(row.to_hash)
  end
  ActiveRecord::Base.connection.reset_pk_sequence!('merchants')
end

task :import, [:items] => :environment do
  CSV.foreach('db/data/items.csv', headers: true) do |row|
    Item.create!(row.to_hash)
  end
  ActiveRecord::Base.connection.reset_pk_sequence!('items')
end

task :import, [:invoices] => :environment do
  CSV.foreach('db/data/invoices.csv', headers: true) do |row|
    if row.to_hash['status'] == 'cancelled'
      status = 0
    elsif row.to_hash['status'] == 'in progress'
      status = 1
    elsif row.to_hash['status'] == 'completed'
      status = 2
    end
    Invoice.create!({ id:          row[0],
                      customer_id: row[1],
                      status:      status,
                      created_at:  row[4],
                      updated_at:  row[5] })
  end
  ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
end

task :import, [:transactions] => :environment do
  CSV.foreach('db/data/transactions.csv', headers: true) do |row|
    if row.to_hash['result'] == 'failed'
      result = 0
    elsif row.to_hash['result'] == 'success'
      result = 1
    end
    Transaction.create!({ id:                          row[0],
                          invoice_id:                  row[1],
                          credit_card_number:          row[2],
                          credit_card_expiration_date: row[3],
                          result:                      result,
                          created_at:                  row[5],
                          updated_at:                  row[6] })
  end
  ActiveRecord::Base.connection.reset_pk_sequence!('transactions')
end

task :import, [:invoice_items] => :environment do
  CSV.foreach('db/data/invoice_items.csv', headers: true) do |row|
    if row.to_hash['status'] == 'pending'
      status = 0
    elsif row.to_hash['status'] == 'packaged'
      status = 1
    elsif row.to_hash['status'] == 'shipped'
      status = 2
    end
    InvoiceItem.create!({ id:          row[0],
                          item_id:     row[1],
                          invoice_id:  row[2],
                          quantity:    row[3],
                          unit_price:  row[4],
                          status:      status,
                          created_at:  row[6],
                          updated_at:  row[7] })
  end
  ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
end

task :import, [:bulk_discounts] => :environment do
  # CSV.foreach('db/data/bulk_discounts.csv', headers: true) do |row|
  #   BulkDiscount.create!(row.to_hash)
  # end
  200.times do 
    Merchant.all.sample.bulk_discounts.create(discount: (rand(5..30)).fdiv(100), threshold: rand(5..30))
  end
  ActiveRecord::Base.connection.reset_pk_sequence!('bulk_discounts')
end

desc 'destroy the tables'
task destroy_all: :environment do
  Holiday.destroy_all
  BulkDiscount.destroy_all
  InvoiceItem.destroy_all
  Item.destroy_all
  Merchant.destroy_all
  Transaction.destroy_all
  Invoice.destroy_all
  Customer.destroy_all
end

desc 'Import all in order'
task all: %i[destroy_all import] # ordered appropriately.
