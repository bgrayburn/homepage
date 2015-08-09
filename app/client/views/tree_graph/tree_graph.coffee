Template.tree_graph.rendered = ->
  $.myp5 = undefined
  s = undefined

  s = (sketch) ->
    x = undefined
    y = undefined
    x = 100
    y = 100

    sketch.setup = ->
      sketch.createCanvas 700, 410

    sketch.draw = ->
      sketch.background 0
      sketch.fill 255
      sketch.rect x, y, 50, 50

  #$.myp5 = new p5(s, 'tree_graph')