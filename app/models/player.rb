class Player < ActiveRecord::Base
  has_many :registrations
  has_many :events, :through => :registrations
  attr_accessible :dci_number, :first_name, :last_name
  has_many :p1_matches, :class_name=>:Match, :foreign_key => :player_1_id
  has_many :p2_matches, :class_name=>:Match, :foreign_key => :player_2_id

  def name
    "#{first_name} #{last_name}"
  end

  def reported_matches
    reported = []
    reported += p1_matches.reported
    reported += p2_matches.reported
    reported
  end

  def has_been_paired?(player)
    paired = false
    paired = true if p1_matches.any? {|m| m.player_2 == player}
    paired = true if p2_matches.any? {|m| m.player_1 == player}
    paired
  end
end
