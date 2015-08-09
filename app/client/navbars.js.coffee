Deps.autorun ->
  Template.navbars.helpers
    level_list: ->
      if typeof(Session.tree_return(Session.get('cur_page'), Session.page_tree)) == 'object'
        lvls = Session.get('cur_page').length
      else
        lvls = Session.get('cur_page').length - 1

      out = []

      for i in [0..lvls]
        if i==0
          i_keys = _.keys(Session.page_tree)
        else
          i_keys = _.keys(Session.tree_return(Session.get("cur_page").slice(0,i),
                          Session.page_tree))
        out.push("keys":i_keys)
      return out

Template.navbars.rendered = ->
  #$("#navbar")[0].append('<div id="logo" class="pull-right" style="position: absolute; top: 7vh; right: 3vw;"><img src="images/logo3d.png" style="opacity: .1"></div>')
  return