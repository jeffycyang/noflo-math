noflo = require 'noflo'

class UnaryMathComponent extends noflo.Component
  constructor: (input, res, inputType = 'number') ->
    @inPorts = {}
    @outPorts = {}
    @inPorts[input] = new noflo.Port inputType
    @inPorts.clear = new noflo.Port 'bang'
    @outPorts[res] = new noflo.Port 'number'

    @input =
      value: null
      group: []
      disconnect: false
    @groups = []

    calculate = =>
      for group in @input.group
        @outPorts[res].beginGroup group
      if @outPorts[res].isAttached()
        @outPorts[res].send @calculate @input.value
      for group in @input.group
        @outPorts[res].endGroup()
      if @outPorts[res].isConnected() and @input.disconnect
        @outPorts[res].disconnect()

    @inPorts[input].on 'begingroup', (group) =>
      @groups.push group
    @inPorts[input].on 'data', (data) =>
      @input =
        value: data
        group: @groups.slice 0
        disconnect: false
      do calculate
    @inPorts[input].on 'endgroup', =>
      @groups.pop()
    @inPorts[input].on 'disconnect', =>
      @input.disconnect = true
      return @outPorts[res].disconnect()

    @inPorts.clear.on 'data', (data) =>
      if @outPorts[res].isConnected()
        for group in @input.group
          @outPorts[res].endGroup()
        if @input.disconnect
          @outPorts[res].disconnect()

      @input =
        value: null
        group: []
        disconnect: false
      @groups = []

exports.UnaryMathComponent = UnaryMathComponent
