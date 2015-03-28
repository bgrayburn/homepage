Session.set("cur_data", [{'Field1 ':1, 'Field2':2, 'Field3':3},{'Field1 ':4, 'Field2':5, 'Field3':6}])
  
Template.data_table.rendered = ->
  #DELETE THE FOLLOWING LINE
  $('#datatable').dataTable(
        "scrollY" : "200px",
        "scrollCollapse" : true,
        "paging" : false,
        "responsive" : true
        )

  

Template.data_table.helpers
  data_arrays: ()->
    _.map Session.get("cur_data"), (e) ->
      "data_row" : _.map(_.values(e), (v)->"val":v)

  data_header: ()->
    cd = Session.get("cur_data")
    if cd.length>0
      _.map(_.keys(cd[0]), (k)-> "heading":k)
    else
      []
