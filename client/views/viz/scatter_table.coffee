Template.scatter_table.rendered = ->
  width = 960
  size = 150
  padding = 19.5
  x = d3.scale.linear().range([
    padding / 2
    size - (padding / 2)
  ])
  y = d3.scale.linear().range([
    size - (padding / 2)
    padding / 2
  ])
  xAxis = d3.svg.axis().scale(x).orient('bottom').ticks(5)
  yAxis = d3.svg.axis().scale(y).orient('left').ticks(5)
  color = d3.scale.category10()
  data = Session.get("cur_data")
  domainByTrait = {}
  traits = d3.keys(data[0]).filter((d) ->
    d != 'species'
  )
  n = traits.length

  plot = (p) ->
    cell = d3.select(this)
    x.domain domainByTrait[p.x]
    y.domain domainByTrait[p.y]
    cell.append('rect').attr('class', 'frame').attr('x', padding / 2).attr('y', padding / 2).attr('width', size - padding).attr 'height', size - padding
    cell.selectAll('circle').data(data).enter().append('circle').attr('cx', (d) ->
      x d[p.x]
    ).attr('cy', (d) ->
      y d[p.y]
    ).attr('r', 3).style 'fill', (d) ->
      color d.species
    return

  # Clear the previously-active brush, if any.

  brushstart = (p) ->
    if brushCell != this
      d3.select(brushCell).call brush.clear()
      x.domain domainByTrait[p.x]
      y.domain domainByTrait[p.y]
      brushCell = this
    return

  # Highlight the selected circles.

  brushmove = (p) ->
    e = brush.extent()
    svg.selectAll('circle').classed 'hidden', (d) ->
      e[0][0] > d[p.x] or d[p.x] > e[1][0] or e[0][1] > d[p.y] or d[p.y] > e[1][1]
    return

  # If the brush is empty, select all circles.

  brushend = ->
    if brush.empty()
      svg.selectAll('.hidden').classed 'hidden', false
    return

  cross = (a, b) ->
    `var n`
    c = []
    n = a.length
    m = b.length
    i = undefined
    j = undefined
    while ++i < n
      j = -1
      while ++j < m
        c.push
          x: a[i]
          i: i
          y: b[j]
          j: j
    c

  traits.forEach (trait) ->
    domainByTrait[trait] = d3.extent(data, (d) ->
      d[trait]
    )
    return
  xAxis.tickSize size * n
  yAxis.tickSize -size * n
  brush = d3.svg.brush().x(x).y(y).on('brushstart', brushstart).on('brush', brushmove).on('brushend', brushend)
  svg = d3.select('#scatter_table').append('svg').attr('width', size * n + padding).attr('height', size * n + padding).append('g').attr('transform', 'translate(' + padding + ',' + padding / 2 + ')')
  svg.selectAll('.x.axis').data(traits).enter().append('g').attr('class', 'x axis').attr('transform', (d, i) ->
    'translate(' + (n - i - 1) * size + ',0)'
  ).each (d) ->
    x.domain domainByTrait[d]
    d3.select(this).call xAxis
    return
  svg.selectAll('.y.axis').data(traits).enter().append('g').attr('class', 'y axis').attr('transform', (d, i) ->
    'translate(0,' + i * size + ')'
  ).each (d) ->
    y.domain domainByTrait[d]
    d3.select(this).call yAxis
    return
  cell = svg.selectAll('.cell').data(cross(traits, traits)).enter().append('g').attr('class', 'cell').attr('transform', (d) ->
    'translate(' + (n - d.i - 1) * size + ',' + d.j * size + ')'
  ).each(plot)
  # Titles for the diagonal.
  cell.filter((d) ->
    d.i == d.j
  ).append('text').attr('x', padding).attr('y', padding).attr('dy', '.71em').text (d) ->
    d.x
  cell.call brush
  brushCell = undefined
  d3.select(self.frameElement).style 'height', size * n + padding + 20 + 'px'