class RemoveBulkDiscountFromHoliday < ActiveRecord::Migration[5.2]
  def change
    remove_reference :holidays, :bulk_discount
  end
end
