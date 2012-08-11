NodeDnDView = Backbone.View.extend
  events:
    "dragstart"   : "on_dragstart" 
    "dragend"     : "on_dragend"
    "dragenter"   : "on_dragenter"
    "dragover"    : "on_dragover"
    "dragleave"   : "on_dragleave"
    "drop"        : "on_drop"
  initialize: ->
    console.log @$el
    _.bindAll this, "on_dragstart", "on_dragend", "on_dragover", "on_dragleave", "on_drop", "on_dragenter"
  on_dragstart: (event) ->
    target = $ event.target
    original_event = event.originalEvent
    target.addClass "dragging"
    original_event.dataTransfer.effectAllowed = 'move'
    @ghost = target.clone().addClass "ghost"
    @dragged = target
  on_dragend: (event) ->
    target = $ event.target
    target.removeClass "dragging"
  on_dragenter: (event) ->
    event.preventDefault()
    target = $ event.target
    node = target.closest(".node").addClass("over")
    original_event = event.originalEvent
    original_event.dataTransfer.dropEffect = 'move'
    try
      return false if node.is(@dragged) ||
                      node.is(@ghost) ||
                      @dragged.parent().closest(".node").is(node)
      node.children(".node_children").prepend(@ghost)
    catch e
      console.log e
    
  on_dragover: (event) ->
    event.preventDefault() # allow drop by preventing default
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
    dnd = new NodeDnDView
            el: @$el
    
    
app = new EMBuddy
  el: $("#embuddy")