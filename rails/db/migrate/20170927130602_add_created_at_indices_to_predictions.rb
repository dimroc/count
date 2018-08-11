class AddCreatedAtIndicesToPredictions < ActiveRecord::Migration[5.1]
  def change
    add_index :predictions, :created_at
    add_index :predictions, :type
  end
end
