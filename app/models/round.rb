class Round < ActiveRecord::Base
  has_many :matches
  belongs_to :event
  attr_accessible :event_id, :number
end
