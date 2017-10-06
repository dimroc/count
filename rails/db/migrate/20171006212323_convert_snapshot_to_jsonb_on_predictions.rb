class ConvertSnapshotToJsonbOnPredictions < ActiveRecord::Migration[5.1]
  def change
    change_column :predictions, :snapshot_data, 'jsonb USING snapshot_data::jsonb'
  end
end
