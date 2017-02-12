class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.string :LName
      t.string :FName
      t.string :init
      t.string :email
      t.string :password
      t.boolean :is_admin
      t.boolean :is_user
      t.boolean :is_super

      t.timestamps
    end
  end
end
