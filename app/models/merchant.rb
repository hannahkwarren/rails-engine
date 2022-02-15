# merchant model

class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  include SearchModule

  def self.top_merchants_by_quantity_sold(number)
    select('merchants.*, SUM(invoice_items.quantity) as count')
      .joins(items: { invoices: :transactions })
      .where(transactions: { result: 'success' }, invoices: { status: 'shipped' })
      .group(:id)
      .order('count desc')
      .limit(number)
  end
end
