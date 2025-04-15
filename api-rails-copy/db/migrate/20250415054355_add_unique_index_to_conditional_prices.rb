class AddUniqueIndexToConditionalPrices < ActiveRecord::Migration[8.0]
  def change
    add_index :conditional_prices, [:option_id, :context_option_id], unique: true, name: "index_conditional_prices_on_option_and_context"
  end
end
