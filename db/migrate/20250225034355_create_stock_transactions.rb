class CreateStockTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :stock_transactions do |t|
      t.references :product_variant, null: false, foreign_key: true
      t.string :quantity
      t.string :type
      t.float :value

      t.timestamps
    end
  end
end
