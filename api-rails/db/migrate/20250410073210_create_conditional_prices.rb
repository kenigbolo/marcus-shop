class CreateConditionalPrices < ActiveRecord::Migration[8.0]
  def change
    create_table :conditional_prices do |t|
      t.references :option, null: false, foreign_key: { to_table: :part_options }
      t.references :context_option, null: false, foreign_key: { to_table: :part_options }
      t.decimal :price_override, null: false

      t.timestamps
    end
  end
end
