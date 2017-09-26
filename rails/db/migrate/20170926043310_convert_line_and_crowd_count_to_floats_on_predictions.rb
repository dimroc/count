class ConvertLineAndCrowdCountToFloatsOnPredictions < ActiveRecord::Migration[5.2]
  def change
    change_column :predictions, :line_count, :float
    change_column :predictions, :crowd_count, :float
  end
end
