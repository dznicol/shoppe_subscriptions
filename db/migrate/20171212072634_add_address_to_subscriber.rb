class AddAddressToSubscriber < ActiveRecord::Migration
  def change
    add_column :shoppe_subscribers, :delivery_address_id, :integer, index: true
    add_foreign_key :shoppe_subscribers, :shoppe_addresses, column: :delivery_address_id
  end
end
