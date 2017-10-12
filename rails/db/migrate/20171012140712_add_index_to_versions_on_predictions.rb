class AddIndexToVersionsOnPredictions < ActiveRecord::Migration[5.1]
  def change
    add_index :predictions, :version
  end
end
