class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def best_discount
    InvoiceItem.joins(:invoice, item: [merchant: :bulk_discounts])
    .where("invoice_items.quantity >= bulk_discounts.threshold and items.id = #{item_id} and invoices.id = #{invoice_id}")
    .select("bulk_discounts.discount, bulk_discounts.id")
    .order("bulk_discounts.discount desc")
    .limit(1)
  end
end
