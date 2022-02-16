class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  include SearchModule

  def self.top_items_by_revenue(number)
    select('items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue')
      .joins(invoice_items: { invoice: :transactions })
      .where(transactions: { result: 'success' })
      .group(:id)
      .order('revenue desc')
      .limit(number)
  end
end
