class CreateCompanies < ActiveRecord::Migration[8.1]
  def change
    create_table :companies do |t|
      t.string   :nombre,         null: false
      t.string   :direccion,      null: false
      t.string   :telefono,       null: false
      t.datetime :fecha_creacion, null: false, default: -> { "CURRENT_TIMESTAMP" }

      t.timestamps
    end
  end
end
