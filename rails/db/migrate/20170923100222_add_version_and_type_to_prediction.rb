class AddVersionAndTypeToPrediction < ActiveRecord::Migration[5.1]
  def change
    add_column :predictions, :type, :string
    add_column :predictions, :version, :string
  end
end
