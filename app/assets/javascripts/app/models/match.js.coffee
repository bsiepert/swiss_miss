class App.Match extends Spine.Model
  @configure 'Match', 'player_1_id', 'player_2_id', 'p1_games_won', 'p2_games_won', 'draws'
  @extend Spine.Model.Ajax
  @url: '/matches'

  to_s: =>
    App.Player.fetch()
    console.log("got a player_1_id: #{@player_1_id}")
    console.log("got a player_2_id: #{@player_2_id}")
    p1 = App.Player.find(@player_1_id);
    p2 = App.Player.find(@player_2_id);
    "#{p1.name()} VS. #{p2.name()}"

window.Match = App.Match
