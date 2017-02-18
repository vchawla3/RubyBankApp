class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.string :transtype
      t.text :sender
      t.text :receiver
      t.string :status
      t.decimal :amount
      t.datetime :start_date
      t.datetime :effective_date

      t.timestamps
    end
  end
end
