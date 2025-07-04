class AddMontoAdicionalToScans < ActiveRecord::Migration[8.0]
  def change
    add_column :scans, :monto_adicional, :integer
  end
end
