class Header extends Written.Parsers.Block
  multiline: false

  constructor: (match) ->
    @match = match

  equals: (current, rendered) ->
    current.outerHTML == rendered.outerHTML

  innerText: ->
    @match[3]

  outerText: ->
    @match[0]

  toEditor: =>
    node = Written.toHTML("<h#{@match[2].length}>")

    for text in @content
      if text.toEditor?
        node.appendChild(text.toEditor())
      else
        node.appendChild(document.createTextNode(text))

    node.insertAdjacentHTML('afterbegin', @match[1])
    node

  toHTML: =>
    node = Written.toHTML("<h#{@match[2].length}>")
    for text in @content
      if text.toHTML?
        node.appendChild(text.toHTML())
      else
        node.appendChild(document.createTextNode(text))
    node

Written.Parsers.register {
  parser: Header
  name: 'header'
  nodes: ['h1', 'h2', 'h3', 'h4', 'h5', 'h6']
  type: 'block'
  rule: /^((#{1,6})\s)(.*)$/i
  getRange: (node, offset, walker) ->
    range = document.createRange()

    if !node.firstChild?
      range.setStart(node, 0)
    else
      while walker.nextNode()
        if walker.currentNode.length < offset
          offset -= walker.currentNode.length
          continue

        range.setStart(walker.currentNode, offset)
        break

    range.collapse(true)
    range

  toString: (node) ->
    node.textContent
}
