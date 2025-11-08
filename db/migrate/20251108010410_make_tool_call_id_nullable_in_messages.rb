class MakeToolCallIdNullableInMessages < ActiveRecord::Migration[7.1]
  def change
    change_column_null :messages, :tool_call_id, true
  end
end
