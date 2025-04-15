class CreateOptionConstraints < ActiveRecord::Migration[8.0]
  def change
    create_table :option_constraints, id: :uuid do |t|
      t.references :part_option, null: false, type: :uuid, foreign_key: true
      t.uuid :related_option_id
      t.integer :constraint_type, null: false

      t.timestamps
    end
  end
end
