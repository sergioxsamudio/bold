class AddMontoFinalToScans < ActiveRecord::Migration[8.0]
  def change
    add_column :scans, :monto_final, :integer
  end
end
