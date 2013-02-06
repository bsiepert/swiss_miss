class App.Match extends Spine.Model
  @configure 'Match', 'player_1_id', 'player_2_id', 'p1_games_won', 'p2_games_won', 'draws'
  @extend Spine.Model.Ajax
  @url: '/matches'
