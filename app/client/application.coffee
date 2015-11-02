#Manage URL
if Session.get("cur_page")==undefined
  start_url = window.location.href
  Meteor.testURL = start_url
  unformatted_page = start_url.split("#")
  Meteor.baseUrl = unformatted_page[0]
  if unformatted_page.length > 1
    #analytics.page(unformatted_page[1])
    formatted_page = unformatted_page[1].split('/').map((e)->e.split("_").join(" "))
    formatted_page.unshift("Brian Rayburn")
    Session.set("cur_page", formatted_page)
  else
    #analytics.page("About")
    Session.set("cur_page", ["Brian Rayburn", "About"])

Tracker.autorun ->
  cur_page = Session.get("cur_page")
  urlized_cur_page = cur_page.slice(1,cur_page.length).map((e)->e.split(" ").join("_"))
  #analytics.page(urlized_cur_page)
  window.location.href = Meteor.baseUrl+"#"+urlized_cur_page.join('/')

Session.page_tree =
                    "Brian Rayburn":
                        "About":"about"
                        "Portfolio":
                          "Analysis":
                            "GDP":
                              "Summary":"gdp"
                              "Exploratory":"gdpExploreNotebook"
                              "Model":"gdpModelNotebook"
                            "Parellel Computation":"mapred"
                          "Visualization":
                            "Baltimore":
                              "Crime":"crime"
                              "Cameras":"geospatial"
                          "Web":
                            "Self Generating Sites":"self_generating_sites"
                          "Art":
                            "eyeCandy":"eyecandy"


#returns value of page in tree
Session.tree_return = (page, tree)->
  cur = tree
  i=0
  while i<page.length
    cur = cur[page[i]]
    i++
  return cur

#TODO: fix the following
Session.find_elem = (elem, tree) ->
  out = false
  if _.contains(_.keys(tree), elem)
    out = [elem]
  else
    subtrees = _.filter(_.keys(tree), (k) -> return typeof(tree[k])=="object")
    _.each(subtrees,
             (k) ->
               temp = Session.find_elem(elem, tree[k])
               if _.isArray(temp)
                 temp.unshift(k)
                 out = temp
             )
  return out

if Session.get("cur_data")==undefined
  Session.set("cur_data", "")

#cascade down page tree when cur_page is set, always fall to a leaf
Tracker.autorun ->
  cur_page = Session.get("cur_page")
  sub_tree = Session.tree_return(cur_page, Session.page_tree)
  switch typeof(sub_tree)
    when 'object'
      first_child = _.keys(sub_tree)[0]
      Session.set("cur_page", cur_page.concat([first_child]))
