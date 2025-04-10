class CreateCarts < ActiveRecord::Migration[8.0]
  def change
    create_table :carts do |t|
      t.uuid :user_id

      t.timestamps
    end
  end
end
