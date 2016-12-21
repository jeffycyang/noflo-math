{UnaryMathComponent} = require '../lib/UnaryMathComponent'

class AbsoluteValue extends UnaryMathComponent
  constructor: ->
    super 'value', 'modulus'

  calculate: (value) ->
    Math.abs(value)

exports.getComponent = -> new AbsoluteValue
