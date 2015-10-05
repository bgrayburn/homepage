if Session.get("cur_page")==undefined
  Session.set("cur_page", ["Brian Rayburn", "About"])

Session.page_tree =
                    "Brian Rayburn":
                        "About":"about"
                        "Portfolio":
                          "GDP":
                            "Summary":"blank"
                            "Notebook":"gdpExploreNotebook"
                          "Baltimore":"geospatial"
                          #  "Crime":"blank"
                          #  "Surveillance":"geospatial"
                          "Concepts":
                            "Map Reduce":"mapred"
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
