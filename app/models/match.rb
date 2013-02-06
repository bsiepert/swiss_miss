class Match < ActiveRecord::Base
  attr_accessible :draws, :p1_games_won, :p2_games_won, :player_1_id, :player_2_id
end
