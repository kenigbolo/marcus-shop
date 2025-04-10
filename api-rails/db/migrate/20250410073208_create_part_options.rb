class CreatePartOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :part_options do |t|
      t.string :name
      t.decimal :base_price
      t.integer :stock_status
      t.references :part, null: false, foreign_key: true

      t.timestamps
    end
  end
end
