class App.Match extends Spine.Model
  @configure 'Match', 'player_1_id', 'player_2_id', 'p1_games_won', 'p2_games_won', 'draws'
  @extend Spine.Model.Ajax
  @url: '/matches'

  to_s: =>
    App.Player.fetch()
    p1 = App.Player.find(@player_1_id);
    p2 = App.Player.find(@player_2_id);
    "#{p1.name()} VS. #{p2.name()}"

  @unreported: ->
    all_matches = @all()
    filterFunc = (item,index,array) ->
      (item.p1_games_won == null)

    unreported = all_matches.filter(filterFunc) 
    unreported

  @reported: ->
    all_matches = @all()
    filterFunc = (item,index,array) ->
      (item.p1_games_won != null)

    unreported = all_matches.filter(filterFunc) 
    unreported

window.Match = App.Match
