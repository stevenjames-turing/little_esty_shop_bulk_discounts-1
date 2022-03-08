class DropHolidayDiscountTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :holiday_discounts
  end
end
