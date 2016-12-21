{MathComponent} = require '../lib/MathComponent'

class AbsoluteValue extends MathComponent
  constructor: ->
    super 'value'

  calculate: (value) ->
    Math.abs(value)

exports.getComponent = -> new AbsoluteValue
