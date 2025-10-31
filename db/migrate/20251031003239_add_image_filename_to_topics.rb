class AddImageFilenameToTopics < ActiveRecord::Migration[7.1]
  def change
    add_column :topics, :image_filename, :string
  end
end
