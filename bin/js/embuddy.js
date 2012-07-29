(function() {
  var BodyNodeView, EMBuddy, Node, NodeView, Nodes, body_node,
    __slice = [].slice;

  Node = Backbone.Model.extend({
    em: 0,
    px: 0,
    parent: null,
    children: null,
    initialize: function() {
      _.bindAll(this, "sync_em", "sync_px");
      this.bind("change:px", this.sync_em);
      this.bind("change:em", this.sync_px);
      this.attributes.children = new Nodes;
      if (this.get("px") !== 0) {
        return this.sync_em(true);
      } else if (this.get("em") !== 0) {
        return this.sync_px(true);
      }
    },
    sync_em: function(silent) {
      var em, parent, px;
      if (silent == null) {
        silent = false;
      }
      px = parseInt(this.get("px"));
      parent = this.get("parent");
      em = parent ? px / parseInt(parent.get("px")) : (0.625 * px) / 10;
      console.log(em);
      return this.set({
        "em": em
      }, {
        silent: silent
      });
    },
    sync_px: function(silent) {
      var em, parent, px;
      if (silent == null) {
        silent = false;
      }
      em = parseFloat(this.get("em"));
      parent = this.get("parent");
      px = parent ? em * parseFloat(parent.get("px")) : (em / 0.625) * 10;
      this.set({
        "px": px
      }, {
        silent: silent
      });
      return console.log(em, px, this.parent);
    },
    add_child: function(child) {
      return this.get("children").add(child);
    }
  });

  Nodes = Backbone.Collection.extend({
    model: Node
  });

  NodeView = Backbone.View.extend({
    parent_node: 1,
    px: null,
    em: null,
    events: {
      "change input": "input_change"
    },
    initialize: function(node) {
      _.bindAll(this, "render", "input_change", "model_change");
      this.set_fields();
      this.model = this.build_model();
      this.model.bind("change", this.model_change);
      return this.render();
    },
    set_fields: function() {
      this.px = this.$el.find(".px");
      return this.em = this.$el.find(".em");
    },
    build_model: function() {
      return new Node({
        parent: this.attributes.parent,
        px: this.$el.find(".px").val()
      });
    },
    render: function() {
      return this.update_size("em", "px");
    },
    update_size: function() {
      var units,
        _this = this;
      units = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return _.each(units, function(unit) {
        var method;
        method = unit === "px" ? parseInt : parseFloat;
        return _this[unit].val("" + (method(_this.model.get(unit))) + unit);
      });
    },
    model_change: function() {
      return this.render();
    },
    input_change: function(e) {
      var target;
      target = $(e.target);
      return this.model.set(target.is(this.px) ? {
        px: target.val()
      } : target.is(this.em) ? {
        em: target.val()
      } : void 0);
    }
  });

  BodyNodeView = NodeView.extend({
    px: null,
    em: null,
    events: {
      "change input": "input_change"
    },
    set_fields: function() {
      var toolbar;
      toolbar = this.$el.find(".embuddy_tools");
      this.px = toolbar.find(".px");
      return this.em = toolbar.find(".em");
    },
    build_model: function() {
      return this.model;
    }
  });

  body_node = null;

  EMBuddy = Backbone.View.extend({
    el: $("#em_buddy"),
    initialize: function() {
      var body, body_view, node_view;
      body = new Node({
        px: 10,
        em: 0.625
      });
      body_view = new BodyNodeView({
        el: this.$el,
        model: body
      });
      body_node = body;
      return node_view = new NodeView({
        el: $(".node"),
        parent_node: body,
        attributes: {
          parent: body
        }
      });
    }
  });

  new EMBuddy();

}).call(this);
