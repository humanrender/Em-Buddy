(function() {
  var EMBuddy, NodeView, app;

  NodeView = Backbone.View.extend({
    events: {
      "dragstart": "on_dragstart",
      "dragend": "on_dragend",
      "dragenter": "on_dragenter",
      "dragover": "on_dragover",
      "dragleave": "on_dragleave",
      "drop": "on_drop"
    },
    initialize: function() {
      console.log(this.$el);
      return _.bindAll(this, "on_dragstart", "on_dragend", "on_dragover", "on_dragleave", "on_drop");
    },
    on_dragstart: function(event) {
      var original_event, target;
      target = $(event.target);
      original_event = event.originalEvent;
      target.addClass("dragging");
      original_event.dataTransfer.effectAllowed = 'move';
      return this.dragged = target;
    },
    on_dragend: function(event) {
      var target;
      target = $(event.target);
      return target.removeClass("dragging");
    },
    on_dragenter: function(event) {
      var original_event, target;
      event.preventDefault();
      target = $(event.target);
      original_event = event.originalEvent;
      if (target.is(".node_contents")) {
        target.closest(".node").addClass("over");
      }
      return original_event.dataTransfer.dropEffect = 'move';
    },
    on_dragover: function(event) {
      return event.preventDefault();
    },
    on_dragleave: function(event) {
      var target;
      target = $(event.target);
      if (target.is(".node_contents")) {
        return target.closest(".node").removeClass("over");
      }
    },
    on_drop: function(event) {
      var container, node, target;
      target = $(event.target);
      node = target.closest(".node").removeClass("over");
      if (node.is(this.dragged)) {
        this.dragged = null;
        return false;
      }
      container = target.is(".node_contents") ? node.children(".node_children") : target.is(".node_children") ? target : node.children(".node_children");
      container.prepend(this.dragged);
      return this.dragged = null;
    }
  });

  EMBuddy = Backbone.View.extend({
    initialize: function() {
      return new NodeView({
        el: this.$el
      });
    }
  });

  app = new EMBuddy({
    el: $("#embuddy")
  });

}).call(this);
