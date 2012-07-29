Node = Backbone.Model.extend
  em: 0
  px: 0
  parent: null
  children: null
  initialize: ->
    _.bindAll this, "sync_em", "sync_px"
    @bind "change:px", @sync_em
    @bind "change:em", @sync_px
    @attributes.children = new Nodes
    if @get("px") != 0 then @sync_em(true)
    else if @get("em") != 0 then @sync_px(true)
  sync_em: (silent = false) ->
    px = parseInt(@get("px"))
    parent = @get "parent"
    em = if parent then px/parseInt(parent.get("px")) else (0.625*px)/10
    console.log(em)
    @set {"em": em}, {silent:silent}
  sync_px: (silent = false) ->
    em = parseFloat(@get("em"))
    parent = @get "parent"
    px = if parent then em*parseFloat(parent.get("px")) else (em/0.625)*10
    @set {"px": px}, {silent:silent}
    console.log(em,px,@parent)
  add_child: (child) ->
    @get("children").add child
    

Nodes = Backbone.Collection.extend
  model: Node

NodeView = Backbone.View.extend
  parent_node: 1
  px: null
  em: null
  events:
    "change input": "input_change"
  initialize: (node) ->
    _.bindAll this, "render", "input_change", "model_change"
    @set_fields()
    @model = @build_model()
    @model.bind "change", @model_change
    @render()
  set_fields: ->
    @px = @$el.find(".px")
    @em = @$el.find(".em")
  build_model: ->
    new Node
      parent: @attributes.parent
      px: @$el.find(".px").val()
  render: -> 
    @update_size("em", "px")
  update_size: (units...) ->
    _.each units, (unit) =>
      method = if unit == "px" then parseInt else parseFloat
      this[unit].val("#{method @model.get unit}#{unit}")
  model_change: -> @render()
  input_change: (e)->
    target = $(e.target)
    @model.set if target.is @px
        {px: target.val()}
    else if target.is @em
        {em: target.val()}

BodyNodeView = NodeView.extend
  px: null
  em: null
  events:
    "change input": "input_change"
  set_fields: ->
    toolbar = @$el.find(".embuddy_tools")
    @px = toolbar.find(".px")
    @em = toolbar.find(".em")
  build_model: ->
    @model
    
    
body_node = null

EMBuddy = Backbone.View.extend
  el: $("#em_buddy")
  initialize: ->
    #body = new Node
    #  px: 10
    #  em: 0.625
    body = new Node
      px: 10
      em: 0.625

    body_view = new BodyNodeView
      el: @$el
      model: body

    body_node = body

      
    node_view = new NodeView
      el: $(".node")
      parent_node: body
      attributes:
        parent: body
    
new EMBuddy()