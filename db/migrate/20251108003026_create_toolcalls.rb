class CreateToolcalls < ActiveRecord::Migration[7.1]
  def change
    create_table :toolcalls do |t|

      t.timestamps
    end
  end
end
