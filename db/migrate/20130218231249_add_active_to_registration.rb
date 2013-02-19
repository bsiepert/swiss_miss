class AddActiveToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :active, :boolean
  end
end
