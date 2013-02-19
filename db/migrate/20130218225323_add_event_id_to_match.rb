class AddEventIdToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :event_id, :integer
  end
end
