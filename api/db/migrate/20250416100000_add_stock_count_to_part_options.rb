class AddStockCountToPartOptions < ActiveRecord::Migration[8.0]
  def change
    add_column :part_options, :stock_count, :integer, default: 0, null: false
  end
end
