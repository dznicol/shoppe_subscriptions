class CreateSubscriberProductBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :shoppe_subscriber_product_blocks do |t|
      t.references :subscriber, foreign_key: { to_table: :shoppe_subscribers }
      t.references :product, foreign_key: { to_table: :shoppe_products }
    end
  end
end
