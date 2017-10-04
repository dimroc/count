class AddShrineSnapshotDensityToPredictions < ActiveRecord::Migration[5.1]
  def change
    add_column :predictions, :snapshot_data, :text
    add_column :predictions, :density_map_data, :text
  end
end
