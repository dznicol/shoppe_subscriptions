class AddTaxToSubscriberTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :shoppe_subscriber_transactions, :tax, :decimal
    add_column :shoppe_subscriber_transactions, :tax_percent, :decimal
  end
end
