class CreateSubscriberOrders < ActiveRecord::Migration
  def change
    create_table :shoppe_subscriber_orders do |t|
      t.integer :subscriber_id
      t.integer :order_id

      t.timestamps null: false

      t.index :order_id
      t.index [:subscriber_id, :order_id], name: 'index_subscriber_orders_subscriber_id_order_id'
      t.index [:order_id, :subscriber_id], name: 'index_subscriber_orders_order_id_subscriber_id'
    end
  end
end
