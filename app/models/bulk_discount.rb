class BulkDiscount < ApplicationRecord
  validates_presence_of :discount
  validates_presence_of :threshold
  validates_numericality_of :threshold
  
  belongs_to :merchant
  has_one :holiday
end