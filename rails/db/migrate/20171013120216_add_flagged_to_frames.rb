class AddFlaggedToFrames < ActiveRecord::Migration[5.1]
  def change
    add_column :frames, :flagged, :boolean, default: false, null: false
  end
end
