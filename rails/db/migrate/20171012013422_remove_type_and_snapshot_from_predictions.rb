class RemoveTypeAndSnapshotFromPredictions < ActiveRecord::Migration[5.1]
  def change
    remove_column :predictions, :snapshot_data
    remove_column :predictions, :type
  end
end
