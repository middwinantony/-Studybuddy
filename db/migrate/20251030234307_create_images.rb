class CreateImages < ActiveRecord::Migration[7.1]
  def change
    create_table :images do |t|
      t.string :name

      t.timestamps
    end

    add_reference :topics, :image, foreign_key: true
  end
end
