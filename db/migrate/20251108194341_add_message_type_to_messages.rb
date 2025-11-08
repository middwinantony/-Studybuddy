class AddMessageTypeToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :message_type, :string
  end
end
