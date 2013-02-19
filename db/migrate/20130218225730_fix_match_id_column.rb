class FixMatchIdColumn < ActiveRecord::Migration
  def up
    rename_column :matches, :event_id, :round_id
  end

  def down
  end
end
