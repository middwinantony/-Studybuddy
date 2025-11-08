class AddAttemptsToChats < ActiveRecord::Migration[7.1]
  def change
    add_column :chats, :attempts, :integer
  end
end
