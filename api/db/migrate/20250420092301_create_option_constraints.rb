class CreateOptionConstraints < ActiveRecord::Migration[8.0]
  def change
    create_table :option_constraints, id: :uuid do |t|
      t.references :source_option, null: false, type: :uuid, foreign_key: { to_table: :part_options }
      t.references :target_option, null: false, type: :uuid, foreign_key: { to_table: :part_options }
      t.integer :constraint_type, null: false

      t.timestamps
    end

    add_index :option_constraints, [:source_option_id, :target_option_id, :constraint_type], unique: true, name: 'index_option_constraints_uniqueness'
  end
end
