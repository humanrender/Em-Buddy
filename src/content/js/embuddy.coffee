Node = Backbone.View.extend
  events:
    dragstart: "on_dragstart" 
    dragend: "on_dragend"
    dragenter: "on_dragenter"
    dragover: "on_dragover"
    dragleave: "on_dragleave"
    drop: "on_drop"
  initialize: ->
    _.bindAll this, "on_dragstart", "on_dragend", "on_dragover", "on_dragleave", "on_drop"
  on_dragstart: (event) ->
    target = $ event.target
    original_event = event.originalEvent
    target.addClass "dragging"
    original_event.dataTransfer.effectAllowed = 'move'
    @dragged = target
    # original_event.dataTransfer.setData('text/html', "<p>1</p>");
  on_dragend: (event) ->
    target = $ event.target
    target.removeClass "dragging"
  on_dragenter: (event) ->
    event.preventDefault()
  on_dragover: (event) ->
    event.preventDefault()
    target = $ event.target
    original_event = event.originalEvent
    if target.is ".node_contents"
      target.closest(".node").addClass "over"
    original_event.dataTransfer.dropEffect = 'move'
  on_dragleave: (event) ->
    target = $ event.target
    if target.is ".node_contents"
      target.closest(".node").removeClass "over"
  on_drop: (event) ->
    console.log(@dragged)
    target = $ event.target
    if target.is ".node_contents"
      target.closest(".node")
            .removeClass("over")
      @dragged.insertAfter(target.closest(".node"))
      @dragged = null
    
  #  dragend: "on_drag_end"
  #  dragover: "on_drag_over"
  #  dragenter: "on_drag_enter"
  #  dragleave: "on_drag_end"
  #  drop: "on_drop"
  #initialize: ->
  #  _.bindAll this, "on_drag_start", "on_drag_end", "on_drag_over", "on_drag_enter", "on_drag_leave", "on_drop", "on_drag_end"
  #  @drag_source = null
  #  
  #on_drag_start: (event) ->
  #  target = $ event.target
  #  target.addClass "dragging"
  #  event.originalEvent.effectAllowed = 'move'
  #  event.originalEvent.dataTransfer.setData('text/html', target.html());
  #  @drag_source = event.target
  #  
  #on_drag_end: (event) ->
  #  target = $ event.target
  #  target.removeClass "dragging"
  #  $(".node.over").removeClass(".over")
  #  
  #on_drag_over: (event) ->
  #  event.preventDefault()
  #  event.originalEvent.dataTransfer.dropEffect = 'move'
  #  return false;
  #  
  #on_drag_enter: (event) ->
  #  console.log $(event.target)
  #  $(event.target).addClass "over"
  #  
  #on_drag_leave: (event) ->
  #  console.log $(event.target)
  #  $(event.target).removeClass "over"
  #
  #on_drop: (event) ->
  #  event.preventDefault();
  #  if (@drag_source != this) 
  #    $(@drag_source).innerHTML = $(event.target).html();
  #    $(event.target).innerHTML = event.originalEvent.dataTransfer.getData('text/html');
  
EMBuddy = Backbone.View.extend
  initialize: ->
    @$el.children(".node").each ->
      new Node
        el: $(this)
    
app = new EMBuddy
  el: $("#embuddy")