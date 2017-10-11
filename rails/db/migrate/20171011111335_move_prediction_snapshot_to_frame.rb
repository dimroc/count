class MovePredictionSnapshotToFrame < ActiveRecord::Migration[5.1]
  def change
    add_reference :predictions, :frame, foreign_key: true

    execute(<<~SQL)
    INSERT INTO frames(raw_data, type, created_at, updated_at)
    SELECT snapshot_data, type, created_at, NOW() FROM predictions
    SQL

    execute(<<~SQL)
    UPDATE predictions SET frame_id = frames.id
    FROM frames WHERE predictions.created_at = frames.created_at
    SQL
  end
end
