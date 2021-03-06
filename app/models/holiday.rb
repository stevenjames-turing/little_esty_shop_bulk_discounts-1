class Holiday < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :date

  has_many :bulk_discounts

  def self.upcoming_holidays(count)
    order(:date)
    .limit(count)
  end

  def discounts
    BulkDiscount.where("bulk_discounts.holiday_id = #{id}")
  end
end