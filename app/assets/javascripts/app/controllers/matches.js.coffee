$ = jQuery.sub()
Match = App.Match

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Match.find(elementID)

class New extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
    
  constructor: ->
    super
    @active @render
    
  render: ->
    @html @view('matches/new')(players: App.Player.all())

  back: ->
    @navigate '/matches'

  submit: (e) ->
    e.preventDefault()
    match = Match.fromForm(e.target).save()
    @navigate '/matches', match.id if match

class Edit extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
  
  constructor: ->
    super
    @active (params) ->
      @change(params.id)
      
  change: (id) ->
    @item = Match.find(id)
    @render()
    
  render: ->
    @html @view('matches/edit')(@item)

  back: ->
    @navigate '/matches'

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/matches'

class Show extends Spine.Controller
  events:
    'click [data-type=edit]': 'edit'
    'click [data-type=back]': 'back'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @item = Match.find(id)
    @render()

  render: ->
    @html @view('matches/show')(@item)

  edit: ->
    @navigate '/matches', @item.id, 'edit'

  back: ->
    @navigate '/matches'

class Index extends Spine.Controller
  events:
    'click [data-type=edit]':    'edit'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=show]':    'show'
    'click [data-type=new]':     'new'

  constructor: ->
    super
    Match.bind 'refresh change', @render
    Match.fetch()
    
  render: =>
    matches = Match.all()
    @html @view('matches/index')(matches: matches)
    
  edit: (e) ->
    item = $(e.target).item()
    @navigate '/matches', item.id, 'edit'
    
  destroy: (e) ->
    item = $(e.target).item()
    item.destroy() if confirm('Sure?')
    
  show: (e) ->
    item = $(e.target).item()
    @navigate '/matches', item.id
    
  new: ->
    @navigate '/matches/new'
    
class App.Matches extends Spine.Stack
  controllers:
    index: Index
    edit:  Edit
    show:  Show
    new:   New
    
  routes:
    '/matches/new':      'new'
    '/matches/:id/edit': 'edit'
    '/matches/:id':      'show'
    '/matches':          'index'
    
  default: 'index'
  className: 'stack matches'
