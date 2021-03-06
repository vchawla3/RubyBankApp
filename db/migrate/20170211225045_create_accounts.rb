class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :acc_number
      t.boolean :is_closed
      t.decimal :balance, default: 0


      t.references :user
      t.timestamps
    end
  end
end
