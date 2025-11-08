class AddTitleToChats < ActiveRecord::Migration[7.1]
  def change
    add_column :chats, :title, :string
  end
end
