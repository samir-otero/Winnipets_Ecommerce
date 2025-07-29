class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :order_number, null: false
      t.decimal :subtotal, precision: 10, scale: 2, default: 0.0
      t.decimal :tax_amount, precision: 10, scale: 2, default: 0.0
      t.decimal :shipping_cost, precision: 10, scale: 2, default: 0.0
      t.decimal :total_amount, precision: 10, scale: 2, default: 0.0
      t.string :status, default: 'pending'
      t.string :payment_id
      t.decimal :gst_rate, precision: 4, scale: 3, default: 0.0
      t.decimal :pst_rate, precision: 4, scale: 3, default: 0.0
      t.decimal :hst_rate, precision: 4, scale: 3, default: 0.0

      t.timestamps
    end

    add_index :orders, :order_number, unique: true
    add_index :orders, :status
  end
end