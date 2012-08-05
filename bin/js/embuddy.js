(function() {
  var EMBuddy, Node, app;

  Node = Backbone.View.extend({
    events: {
      dragstart: "on_dragstart",
      dragend: "on_dragend",
      dragenter: "on_dragenter",
      dragover: "on_dragover",
      dragleave: "on_dragleave",
      drop: "on_drop"
    },
    initialize: function() {
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
      return event.preventDefault();
    },
    on_dragover: function(event) {
      var original_event, target;
      event.preventDefault();
      target = $(event.target);
      original_event = event.originalEvent;
      if (target.is(".node_contents")) {
        target.closest(".node").addClass("over");
      }
      return original_event.dataTransfer.dropEffect = 'move';
    },
    on_dragleave: function(event) {
      var target;
      target = $(event.target);
      if (target.is(".node_contents")) {
        return target.closest(".node").removeClass("over");
      }
    },
    on_drop: function(event) {
      var target;
      console.log(this.dragged);
      target = $(event.target);
      if (target.is(".node_contents")) {
        target.closest(".node").removeClass("over");
        this.dragged.insertAfter(target.closest(".node"));
        return this.dragged = null;
      }
    }
  });

  EMBuddy = Backbone.View.extend({
    initialize: function() {
      return this.$el.children(".node").each(function() {
        return new Node({
          el: $(this)
        });
      });
    }
  });

  app = new EMBuddy({
    el: $("#embuddy")
  });

}).call(this);
