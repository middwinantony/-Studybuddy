class AddScoreToChats < ActiveRecord::Migration[7.1]
  def change
    add_column :chats, :score, :integer
  end
end
