class AddHolidaytoBulkDiscount < ActiveRecord::Migration[5.2]
  def change
    add_reference :bulk_discounts, :holiday, foreign_key: true
  end
end
