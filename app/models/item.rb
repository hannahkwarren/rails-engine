class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy

  # after_destroy :delete_invoice_too

  include SearchModule

  # private
  # def delete_invoice_too 
  #   self.invoices.each do |inv|
  #     if inv.invoice_items.count == 1
  #       inv.destroy
  #     else
  #       return "No invoices to delete."
  #     end
  #   end
  # end

end
