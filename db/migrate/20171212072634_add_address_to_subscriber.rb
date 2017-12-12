class AddAddressToSubscriber < ActiveRecord::Migration
  def change
    # add_reference :shoppe_subscribers, :recipient_address, index: true, foreign_key: true
    add_column :shoppe_subscribers, :recipient_address_id, :integer, index: true
    # add_index :shoppe_subscribers, :recipient_address_id
    add_foreign_key :shoppe_subscribers, :shoppe_addresses, column: :recipient_address_id
  end
end
