class ConvertLineAndCrowdCountToFloatsOnPredictions < ActiveRecord::Migration[5.1]
  def change
    change_column :predictions, :line_count, :float
    change_column :predictions, :crowd_count, :float
  end
end
