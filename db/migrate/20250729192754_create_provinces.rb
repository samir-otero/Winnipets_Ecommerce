class CreateProvinces < ActiveRecord::Migration[8.0]
  def change
    create_table :provinces do |t|
      t.string :name, null: false
      t.string :abbreviation, null: false, limit: 2
      t.decimal :gst_rate, precision: 4, scale: 3, default: 0.0
      t.decimal :pst_rate, precision: 4, scale: 3, default: 0.0
      t.decimal :hst_rate, precision: 4, scale: 3, default: 0.0

      t.timestamps
    end

    add_index :provinces, :abbreviation, unique: true
  end
end