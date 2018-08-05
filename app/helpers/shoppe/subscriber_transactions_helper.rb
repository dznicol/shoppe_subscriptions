module Shoppe
  module SubscriberTransactionsHelper
    def currency_symbol(currency_code)
      ISO4217::Currency.from_code(currency_code).try(:symbol) || Shoppe.settings.currency_unit
    end
  end
end
