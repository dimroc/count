class CorrectTypeOnFrames < ActiveRecord::Migration[5.1]
  def change
    execute(<<~SQL)
    UPDATE frames SET type = 'Frame::Shakecam' WHERE type = 'Prediction::Shakecam';
    UPDATE frames SET type = 'Frame::Mall' WHERE type = 'Prediction::Mall';
    SQL
  end
end
