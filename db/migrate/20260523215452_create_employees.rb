class CreateEmployees < ActiveRecord::Migration[8.1]
  def change
    create_table :employees do |t|
      t.string  :nombre,   null: false
      t.string  :apellido, null: false
      t.string  :correo,   null: false
      t.string  :cargo,    null: false
      t.decimal :salario,  precision: 12, scale: 2, null: false

      t.references :company, null: false, foreign_key: true

      t.timestamps
    end

    add_index :employees, :correo, unique: true
  end
end
