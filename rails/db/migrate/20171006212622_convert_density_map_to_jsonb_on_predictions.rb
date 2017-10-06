class ConvertDensityMapToJsonbOnPredictions < ActiveRecord::Migration[5.1]
  def change
    change_column :predictions, :density_map_data, 'jsonb USING density_map_data::jsonb'
  end
end
