class CreateFrames < ActiveRecord::Migration[5.1]
  def change
    create_table :frames do |t|
      t.jsonb :raw_data
      t.string :type

      t.timestamps
    end

    add_index :frames, :type
    add_index :frames, :created_at
  end
end
