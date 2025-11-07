class AddColumnsToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :model_id, :string
    add_column :messages, :input_tokens, :integer
    add_column :messages, :output_tokens, :integer
    add_reference :messages, :tool_call, null: false, foreign_key: true
  end
end
