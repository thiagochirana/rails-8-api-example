class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :street, null: false
      t.string :reference_point
      t.string :number, null: false
      t.string :complement
      t.string :neighborhood
      t.string :city, null: false
      t.string :state, null: false, limit: 2
      t.string :country, null: false, default: "Brasil"
      t.string :zip_code, null: false

      t.timestamps
    end
  end
end
