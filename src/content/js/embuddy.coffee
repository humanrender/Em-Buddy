NodeView = Backbone.View.extend
  events:
    "dragstart"   : "on_dragstart" 
    "dragend"     : "on_dragend"
    "dragenter"   : "on_dragenter"
    "dragover"    : "on_dragover"
    "dragleave"   : "on_dragleave"
    "drop"        : "on_drop"
  initialize: ->
    console.log @$el
    _.bindAll this, "on_dragstart", "on_dragend", "on_dragover", "on_dragleave", "on_drop"
  on_dragstart: (event) ->
    target = $ event.target
    original_event = event.originalEvent
    target.addClass "dragging"
    original_event.dataTransfer.effectAllowed = 'move'
    @dragged = target
  on_dragend: (event) ->
    target = $ event.target
    target.removeClass "dragging"
  on_dragenter: (event) ->
    event.preventDefault()
    target = $ event.target
    original_event = event.originalEvent
    if target.is ".node_contents"
      target.closest(".node").addClass "over"
    original_event.dataTransfer.dropEffect = 'move'
  on_dragover: (event) ->
    event.preventDefault()
    
  on_dragleave: (event) ->
    target = $ event.target
    if target.is ".node_contents"
      target.closest(".node").removeClass "over"
  on_drop: (event) ->
    target = $ event.target
    node = target.closest(".node").removeClass("over")
    if node.is(@dragged)
      @dragged = null
      return false 
    container = if target.is ".node_contents"
      node.children(".node_children")
    else if target.is ".node_children"
      target
    else
      node.children(".node_children")
    container.prepend(@dragged)
    @dragged = null
    
  
EMBuddy = Backbone.View.extend
  initialize: ->
    new NodeView
      el: @$el
    
app = new EMBuddy
  el: $("#embuddy")