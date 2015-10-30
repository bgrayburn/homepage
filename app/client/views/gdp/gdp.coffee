Template.gdp.events
  'click button#gdpExpBtn': (e,t)->
    cur_page = Session.get("cur_page")
    next_page = cur_page.slice(0,cur_page.length-1).concat(["Exploratory"])
    Session.set("cur_page", next_page)
