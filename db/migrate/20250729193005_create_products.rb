class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.decimal :sale_price, precision: 10, scale: 2
      t.integer :stock_quantity, default: 0
      t.string :sku, null: false
      t.decimal :weight, precision: 8, scale: 3
      t.boolean :is_active, default: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end

    add_index :products, :sku, unique: true
    add_index :products, :is_active
  end
end