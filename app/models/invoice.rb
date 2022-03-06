class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, 'in progress', :complete]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_revenue
    revenue = 0
    invoice_items.each do |ii|
      revenue += (((1 - ii.best_discount) * ii.unit_price) * ii.quantity)
    end
    revenue
  end
end
