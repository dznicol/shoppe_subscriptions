class RenameGiftToSubscriberGift < ActiveRecord::Migration
  def change
    rename_table :shoppe_gifts, :shoppe_subscriber_gifts
  end
end
