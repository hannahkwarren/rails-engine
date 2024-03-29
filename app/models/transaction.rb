# model Transaction

class Transaction < ApplicationRecord
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :items, through: :invoice_items
end
