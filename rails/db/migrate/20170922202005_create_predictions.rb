class CreatePredictions < ActiveRecord::Migration[5.1]
  def change
    create_table :predictions do |t|
      t.integer :crowd_count
      t.integer :line_count

      t.timestamps
    end
  end
end
