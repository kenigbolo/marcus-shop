class CreateCartItemOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :cart_item_options, id: :uuid do |t|
      t.references :cart_item, null: false, type: :uuid, foreign_key: true
      t.references :part_option, null: false, type: :uuid, foreign_key: true
      t.decimal :price_applied

      t.timestamps
    end
  end
end
