class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :postal_code
      t.references :province, null: false, foreign_key: true
      t.string :address_type

      t.timestamps
    end
  end
end
