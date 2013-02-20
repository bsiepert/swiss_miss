class Event < ActiveRecord::Base
  has_many :rounds
  has_many :registrations
  has_many :players, :through => :registrations
  attr_accessible :name, :date


  def rank_players
    points = points_per_player
    player_win_percentages = match_win_percentages(points)
    player_game_win_percentages = game_win_percentages(points)

    #TODO: extract method
    player_data = []
    points.each do |player, results|
      matches_played = player.reported_matches.length
      puts "matches played: #{matches_played}"

      match_points, game_points, opponents, games_played = results

      omwp = average_win_percentage(opponents, player_win_percentages, matches_played)
      
      game_percentage = player_game_win_percentages[player]
      
      ogwp = average_win_percentage(opponents, player_game_win_percentages, matches_played)

      player_data << [player, match_points, omwp, game_percentage, ogwp]
    end

    #TODO: extract method
    sorted_players = player_data.sort do |a,b|
      #b[1] <=> a[1]
      # swapping a and b to sort descending
      p1, mp1, omwp1, gp1, ogwp1 = b
      p2, mp2, omwp2, gp2, ogwp2 = a

      # refactor meeeeee
      #puts "mp: #{p1.first_name}#{mp1} vs. #{p2.first_name}#{mp2}"
      if mp1 > mp2
        1
      elsif mp1 < mp2
        -1
      else
        #puts "omwp: #{p1.first_name}#{omwp1} vs. #{p2.first_name}#{omwp2}"
        if omwp1 > omwp2
          1
        elsif omwp1 < omwp2
          -1
        else
          #puts "gp: #{p1.first_name}#{gp1} vs. #{p2.first_name}#{gp2}"
          if gp1 > gp2
            1
          elsif gp1 < gp2
            -1
          else
            #puts "ogwp: #{p1.first_name}#{ogwp1} vs. #{p2.first_name}#{ogwp2}"
            if ogwp1 > ogwp2
              1
            elsif ogwp1 < ogwp2
              -1
            else
            #rando cardissian!
              #puts "rando!"
              1
            end
          end
        end
      end
    end
    sorted_players
  end
  def display_standings
    ranked_players = rank_players

    ranked_players.each do |player, match_points, omwp, game_percentage, ogwp|
      pad_length = 20-player.name.length
      puts "%s%s\t%.2f\t%.2f\t%.2f\t%.2f" %[player.first_name, " "*pad_length, match_points, omwp, game_percentage,ogwp]
    end

  end
  private
  
  def average_win_percentage(players, win_percentages, number_of_matches)
    points_sum = 0
    players.each do |player|
      points_sum += win_percentages[player]
    end
    points_sum/number_of_matches
  end

  #TODO: refactor mee
  ###
  def game_win_percentages(points)
    player_game_points = {} 
    points.each do |player,results|
      game_points = results[1]
      num_games = results[3]
      player_game_points[player] = win_percentage(game_points, num_games)
    end
    player_game_points
  end

  def match_win_percentages(points)
    player_match_points = {} 

    points.each do |player,results|
      match_points = results[0]
      num_matches = player.reported_matches.length
      player_match_points[player] = win_percentage(match_points, num_matches)
    end

    player_match_points
  end
  #### 
  
  def win_percentage(points, amount_played)
    puts "amount played: #{amount_played}"
    win_percentage = points/(amount_played * 3.0)
    win_percentage =(win_percentage * 100).round / 100.0 
    win_percentage = 0.33 if win_percentage < 0.33
    win_percentage
  end

  def points_per_player
    player_points = {}
    players.each do |player|
      player_points[player] =[0, 0, [],0]
    end

    rounds.each do |round|
      round.matches.reported.each do |match|
        p1_points, p2_points = match.points
        p1, p1_mp, p1_gp, p1_gpl = p1_points
        p2, p2_mp, p2_gp, p2_gpl= p2_points


        #TODO: games played and opponents can be derived 
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
  
end
