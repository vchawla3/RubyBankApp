class CreateFriends < ActiveRecord::Migration[5.0]
  def change
    create_table :friends do |t|
      t.string :friend1
      t.string :friend2

      t.timestamps
    end
  end
end
