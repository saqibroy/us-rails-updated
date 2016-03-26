class AddArabicToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :arabic, :boolean
  end
end
