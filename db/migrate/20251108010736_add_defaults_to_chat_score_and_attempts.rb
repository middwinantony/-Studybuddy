class AddDefaultsToChatScoreAndAttempts < ActiveRecord::Migration[7.1]
  def change
    change_column_default :chats, :score, 0
    change_column_default :chats, :attempts, 0
  end
end
