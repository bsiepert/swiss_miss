class Match < ActiveRecord::Base
  belongs_to :player_1, :class_name => :Player, :foreign_key => :player_1_id
  belongs_to :player_2, :class_name => :Player, :foreign_key => :player_2_id
  belongs_to :round
  attr_accessible :draws, :player_1, :player_2, :p1_games_won, :p2_games_won, :player_1_id, :player_2_id


  def before_save
    if ((p1_games_won>0 || p2_games_won > 0) && draws.nil?)
      draws = 0
    end
  end

  scope :reported, lambda { where("p1_games_won is not NULL")}
  scope :with_player, lambda { |player| where("player_1_id =  ? or player_2_id = ?", player.id, player.id) }
  

  def game_points(games_won,draws)
    (games_won * 3)+(draws * 1)
  end
  
  def points
    return nil if p1_games_won.blank?
    p1_game_points = game_points(p1_games_won, draws)
    p2_game_points = game_points(p2_games_won, draws)

    games_played = p1_games_won + p2_games_won

    if (draws && draws > 0)
      [[player_1, 1, p1_game_points, games_played],
      [player_2, 1, p2_games_points, games_played]]
    else
      if p1_games_won > p2_games_won
        [[player_1, 3, p1_game_points, games_played],
        [player_2, 0, p2_game_points, games_played]]
      else
        [[player_1, 0, p1_game_points, games_played],
        [player_2, 3, p2_game_points, games_played]]
      end
    end

  end
end
