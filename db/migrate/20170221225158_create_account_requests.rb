class CreateAccountRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :account_requests do |t|
      t.integer :userid
      t.boolean :created, default: false

      t.references :user
      t.timestamps
    end
  end
end
