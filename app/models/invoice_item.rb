class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_many :transactions, through: :invoice

  after_destroy :delete_invoice_too

  private
  def delete_invoice_too 
    if self.invoice.invoice_items.count == 0
      invoice.destroy
    else
      return "No invoices to delete."
    end
  end
end
