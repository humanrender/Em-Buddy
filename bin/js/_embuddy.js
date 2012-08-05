(function() {
  var BodyNodeView, EMBuddy, Node, NodeView, Nodes,
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
      this.bind("change", this.sync);
      this.attributes.children = new Nodes;
      if (this.get("px") !== 0) {
        return this.sync_em(true);
      } else if (this.get("em") !== 0) {
        return this.sync_px(true);
      }
    },
    sync: function() {
      return this.update_children();
    },
    sync_em: function(event, val, changes) {
      var em, parent, px;
      if (event == null) {
        event = null;
      }
      if (val == null) {
        val = null;
      }
      if (changes == null) {
        changes = null;
      }
      px = parseInt(this.get("px"));
      parent = this.get("parent");
      em = parent ? px / parseInt(parent.get("px")) : (0.625 * px) / 10;
      return this.set({
        "em": em
      }, {
        silent: !event
      });
    },
    sync_px: function(event, val, changes) {
      var em, parent, px;
      if (event == null) {
        event = null;
      }
      if (val == null) {
        val = null;
      }
      if (changes == null) {
        changes = null;
      }
      em = parseFloat(this.get("em"));
      parent = this.get("parent");
      px = parent ? em * parseFloat(parent.get("px")) : (em / 0.625) * 10;
      return this.set({
        "px": px
      }, {
        silent: !event
      });
    },
    update_children: function() {
      var children;
      children = this.get("children");
      return children.each(function(child) {
        return child.sync_em(true);
      });
    },
    add_child: function(child, options) {
      var children, node;
      if (options == null) {
        options = {
          silent: false
        };
      }
      children = this.get("children");
      children.add(child);
      node = children.at(children.length - 1);
      if (!options.silent) {
        this.trigger("add_child", node);
      }
      return node;
    }
  });

  Nodes = Backbone.Collection.extend({
    model: Node
  });

  NodeView = Backbone.View.extend({
    parent_node: 1,
    px: null,
    em: null,
    children_selector: ">",
    events: {
      "change input": "input_change"
    },
    initialize: function() {
      var nodes;
      _.bindAll(this, "render", "input_change", "model_change", "model_add_child");
      this.set_fields();
      this.model.bind("change", this.model_change);
      this.model.bind("add_child", this.model_add_child);
      this.render();
      if ((nodes = this.$el.find("" + this.children_selector + " .node"))) {
        return this.init_children(nodes);
      }
    },
    init_children: function(nodes) {
      var self;
      self = this;
      return nodes.each(function() {
        var $el, em, node, px;
        $el = $(this);
        node = self.model.add_child({
          parent: self.model,
          px: _.isEmpty((px = $el.find("> fieldset .px").val())) ? 0 : px,
          em: _.isEmpty((em = $el.find("> fieldset .em").val())) ? 0 : em
        }, {
          silent: true
        });
        return new NodeView({
          model: node,
          el: $el
        });
      });
    },
    set_fields: function() {
      this.px = this.$el.find("> fieldset .px");
      return this.em = this.$el.find("> fieldset .em");
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
        return _this[unit].val("" + (Math.round(method(_this.model.get(unit)) * 1000) / 1000) + unit);
      });
    },
    model_change: function() {
      return this.render();
    },
    model_add_child: function(node) {
      return new NodeView({
        model: node
      });
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
    children_selector: ".embuddy_viewport >",
    initialize: function() {
      var self;
      self = this;
      return NodeView.prototype.initialize.call(this);
    },
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
    },
    render: function() {
      return this.update_size("em", "px");
    }
  });

  EMBuddy = Backbone.View.extend({
    el: $("#em_buddy"),
    initialize: function() {
      var body, body_node, body_view;
      body = new Node({
        px: 10,
        em: 0.625
      });
      body_view = new BodyNodeView({
        el: this.$el,
        model: body
      });
      return body_node = body;
    }
  });

  new EMBuddy();

}).call(this);
