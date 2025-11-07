class AddRoleToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :role, :string
  end
end
