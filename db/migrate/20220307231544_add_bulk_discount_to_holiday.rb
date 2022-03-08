class AddBulkDiscountToHoliday < ActiveRecord::Migration[5.2]
  def change
    add_reference :holidays, :bulk_discount, foreign_key: true
  end
end
