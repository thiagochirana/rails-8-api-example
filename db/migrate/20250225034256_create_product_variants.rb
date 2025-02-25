class CreateProductVariants < ActiveRecord::Migration[8.0]
  def change
    create_table :product_variants do |t|
      t.string :size
      t.string :color
      t.string :estampa
      t.string :material_type
      t.string :capacity_ml
      t.string :weight_g
      t.string :stock_quantity
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
