class AddChatToMessages < ActiveRecord::Migration[7.1]
  def change
    add_reference :messages, :chat, index: true unless column_exists?(:messages, :chat_id)
  end
end
