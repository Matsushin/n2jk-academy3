class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :body
      t.string :user_id
      t.string :post_id

      t.timestamps null: false
    end
    add_index :comments, :post_id
  end
end
