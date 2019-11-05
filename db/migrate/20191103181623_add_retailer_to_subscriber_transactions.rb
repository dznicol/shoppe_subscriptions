class AddRetailerToSubscriberTransactions < ActiveRecord::Migration[5.2]
  def change
    add_reference :shoppe_subscriber_transactions, :retailer, foreign_key: { to_table: :shoppe_retailers }
  end
end
