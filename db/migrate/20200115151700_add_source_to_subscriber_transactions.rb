class AddSourceToSubscriberTransactions < ActiveRecord::Migration[5.2]
    def change
        add_column :shoppe_subscriber_transactions, :source_id, :string
    end
  end