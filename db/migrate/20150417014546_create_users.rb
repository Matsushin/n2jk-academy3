class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :nickname
      t.string :icon
      t.string :github_id
      t.string :github_token

      t.timestamps null: false
    end
  end
end
