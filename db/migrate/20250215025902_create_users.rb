class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.date   :birthday
      t.string :document_number # --> it can be CPF or CNPJ
      t.string :document_type, null: false
      t.string :role
      t.string :email, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
    add_index :users, :email,           unique: true
    add_index :users, :document_number, unique: true
  end
end
