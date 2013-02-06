$ = jQuery.sub()
Player = App.Player

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Player.find(elementID)

class New extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
    
  constructor: ->
    super
    @active @render
    
  render: ->
    @html @view('players/new')

  back: ->
    @navigate '/players'

  submit: (e) ->
    e.preventDefault()
    player = Player.fromForm(e.target).save()
    @navigate '/players', player.id if player

class Edit extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
  
  constructor: ->
    super
    @active (params) ->
      @change(params.id)
      
  change: (id) ->
    @item = Player.find(id)
    @render()
    
  render: ->
    @html @view('players/edit')(@item)

  back: ->
    @navigate '/players'

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/players'

class Show extends Spine.Controller
  events:
    'click [data-type=edit]': 'edit'
    'click [data-type=back]': 'back'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @item = Player.find(id)
    @render()

  render: ->
    @html @view('players/show')(@item)

  edit: ->
    @navigate '/players', @item.id, 'edit'

  back: ->
    @navigate '/players'

class Index extends Spine.Controller
  events:
    'click [data-type=edit]':    'edit'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=show]':    'show'
    'click [data-type=new]':     'new'

  constructor: ->
    super
    Player.bind 'refresh change', @render
    Player.fetch()
    
  render: =>
    players = Player.all()
    @html @view('players/index')(players: players)
    
  edit: (e) ->
    item = $(e.target).item()
    @navigate '/players', item.id, 'edit'
    
  destroy: (e) ->
    item = $(e.target).item()
    item.destroy() if confirm('Sure?')
    
  show: (e) ->
    item = $(e.target).item()
    @navigate '/players', item.id
    
  new: ->
    @navigate '/players/new'
    
class App.Players extends Spine.Stack
  controllers:
    index: Index
    edit:  Edit
    show:  Show
    new:   New
    
  routes:
    '/players/new':      'new'
    '/players/:id/edit': 'edit'
    '/players/:id':      'show'
    '/players':          'index'
    
  default: 'index'
  className: 'stack players'