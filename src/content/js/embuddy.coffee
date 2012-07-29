Node = Backbone.Model.extend
  em: 0
  px: 0
  parent: null
  children: null
  initialize: ->
    _.bindAll this, "sync_em", "sync_px"
    @bind "change:px", @sync_em
    @bind "change:em", @sync_px
    @bind "change", @sync
    @attributes.children = new Nodes
    
    if @get("px") != 0 then @sync_em(true)
    else if @get("em") != 0 then @sync_px(true)
  sync: ->
    @update_children()
  sync_em: (event = null, val = null, changes = null) ->
    px = parseInt(@get("px"))
    parent = @get "parent"
    em = if parent then px/parseInt(parent.get("px")) else (0.625*px)/10
    @set {"em": em}, {silent:!event}
  sync_px: (event = null, val = null, changes = null) ->
    em = parseFloat(@get("em"))
    parent = @get "parent"
    px = if parent then em*parseFloat(parent.get("px")) else (em/0.625)*10
    @set {"px": px}, {silent:!event}
  update_children: ->
    children = @get("children")
    children.each (child) ->
      child.sync_em(true)
  add_child: (child, options = {silent:false}) ->
    children = @get("children")
    children.add child
    node = children.at(children.length-1)
    @trigger "add_child", node unless options.silent
    node
    

Nodes = Backbone.Collection.extend
  model: Node

NodeView = Backbone.View.extend
  parent_node: 1
  px: null
  em: null
  children_selector: ">"
  events:
    "change input": "input_change"
  initialize:->
    _.bindAll this, "render", "input_change", "model_change", "model_add_child"
    @set_fields()
    @model.bind "change", @model_change
    @model.bind "add_child", @model_add_child
    @render()
    
    if(nodes  = @$el.find("#{@children_selector} .node"))
      @init_children(nodes)
  init_children: (nodes) ->
    self = this
    nodes.each ->
        $el = $ this
        node = self.model.add_child {
          parent: self.model
          px: if _.isEmpty((px = $el.find("> fieldset .px").val())) then 0 else px
          em: if _.isEmpty((em = $el.find("> fieldset .em").val())) then 0 else em
        }, {silent:true}
        new NodeView
          model: node
          el: $el
  set_fields: ->
    @px = @$el.find("> fieldset .px")
    @em = @$el.find("> fieldset .em")
  render: -> 
    @update_size("em", "px")
  update_size: (units...) ->
    _.each units, (unit) =>
      method = if unit == "px" then parseInt else parseFloat
      this[unit].val("#{Math.round(method(@model.get unit)*1000)/1000}#{unit}")
  model_change: -> @render()
  model_add_child: (node)->
    new NodeView
      model: node
  input_change: (e)->
    target = $(e.target)
    @model.set if target.is @px
        {px: target.val()}
    else if target.is @em
        {em: target.val()}

BodyNodeView = NodeView.extend
  px: null
  em: null
  children_selector: ".embuddy_viewport >"
  initialize: ->
    self = this
    NodeView.prototype.initialize.call this
    
        
  events:
    "change input": "input_change"
  set_fields: ->
    toolbar = @$el.find(".embuddy_tools")
    @px = toolbar.find(".px")
    @em = toolbar.find(".em")
  build_model: ->
    @model
  render: -> 
    @update_size("em", "px")

EMBuddy = Backbone.View.extend
  el: $("#em_buddy")
  initialize: ->
    body = new Node
      px: 10
      em: 0.625

    body_view = new BodyNodeView
      el: @$el
      model: body

    body_node = body
    
new EMBuddy()