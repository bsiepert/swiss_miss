class Event < ActiveRecord::Base
  has_many :rounds
  has_many :registrations
  attr_accessible :date
end
