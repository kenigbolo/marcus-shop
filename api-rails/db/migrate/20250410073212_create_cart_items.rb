class CreateCartItems < ActiveRecord::Migration[8.0]
  def change
    create_table :cart_items, id: :uuid do |t|
      t.references :product, null: false, type: :uuid, foreign_key: true
      t.integer :quantity
      t.references :cart, null: false, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
