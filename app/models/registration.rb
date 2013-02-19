class Registration < ActiveRecord::Base
  belongs_to :event
  belongs_to :player
  attr_accessible :event_id, :player_id
  scope :active, where(:active => true)

  
end
