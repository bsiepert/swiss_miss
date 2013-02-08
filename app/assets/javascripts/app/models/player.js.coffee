class App.Player extends Spine.Model
  @configure 'Player', 'first_name', 'last_name'
  @extend Spine.Model.Ajax

  name: =>
    "#{@first_name} #{@last_name}"
 
 window.Player = App.Player
