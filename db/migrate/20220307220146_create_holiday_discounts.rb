class CreateHolidayDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :holiday_discounts do |t|
      t.references :holiday, foreign_key: true
      t.references :bulk_discount, foreign_key: true

      t.timestamps
    end
  end
end
