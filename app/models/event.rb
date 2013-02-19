class Event < ActiveRecord::Base
  has_many :rounds
  has_many :registrations
  has_many :players, :through => :registrations
  attr_accessible :name, :date

  def points_per_player
    player_points = {}
    players.each do |player|
      player_points[player] =[0, 0, [],0]
    end

    rounds.each do |round|
      round.matches.each do |match|
        p1_points, p2_points = match.points
        p1, p1_mp, p1_gp, p1_gpl = p1_points
        p2, p2_mp, p2_gp, p2_gpl= p2_points


        player_points[p1][0] += p1_mp unless p1_mp.nil?
        player_points[p1][1] += p1_gp unless p1_gp.nil?
        player_points[p1][2] << p2
        player_points[p1][3] += p1_gpl unless p1_gpl.nil?

        player_points[p2][0] += p2_mp unless p2_mp.nil?
        player_points[p2][1] += p2_gp unless p2_gp.nil?
        player_points[p2][2] << p1
        player_points[p2][3] += p2_gpl unless p2_gpl.nil?

      end
    end

    player_points
  end
  
  def average_win_percentage(players, win_percentages)
    points_sum = 0
    players.each do |player|
      points_sum += win_percentages[player]
    end
    points_sum/rounds.length
  end

  def rank_players
    points = points_per_player
    player_win_percentages = win_percentages(points)
    player_game_win_percentages = game_win_percentages(points)

    points.each do |player, res|
      match_points, game_points, opponents, games_played = res
      omwp = average_win_percentage(opponents, player_win_percentages)
      ogwp = average_win_percentage(opponents, player_game_win_percentages)
      pad_length = 20-player.name.length
      puts "#{player.name}#{" "*pad_length}#{match_points}\t#{omwp}\t#{game_points}\t#{ogwp}"
    end
  end

  def game_win_percentages(points)
    player_game_points = {} 
    points.each do |player,results|
      player_game_points[player] = game_win_percentage(results[1], results[3])
    end
    player_game_points
  end

  def win_percentages(points)
    player_match_points = {} 
    points.each do |player,results|
      player_match_points[player] = match_win_percentage(results[0])
    end
    player_match_points
  end
  
  def game_win_percentage(points, games_played)
    win_percentage = points/(games_played * 3.0)
    win_percentage = 0.33 if win_percentage < 0.33
    win_percentage
  end
  
  def match_win_percentage(points)
    win_percentage = points/(rounds.length * 3.0)
    win_percentage = 0.33 if win_percentage < 0.33
    win_percentage
  end

end
