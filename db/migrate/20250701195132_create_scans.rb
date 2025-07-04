class CreateScans < ActiveRecord::Migration[8.0]
  def change
    create_table :scans do |t|
      t.text :content

      t.timestamps
    end
  end
end
