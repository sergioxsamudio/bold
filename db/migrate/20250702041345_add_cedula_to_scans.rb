class AddCedulaToScans < ActiveRecord::Migration[8.0]
  def change
    add_column :scans, :cedula, :string
  end
end
