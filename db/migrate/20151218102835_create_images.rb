class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :image_title
      t.text :description
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
