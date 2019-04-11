class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :text
      t.binary :image

      t.timestamps
    end
  end
end
