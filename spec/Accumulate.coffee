noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai'
  path = require 'path'
  baseDir = path.resolve __dirname, '../'
else
  baseDir = 'noflo-math'

describe 'Accumulate component', ->
  c = null
  cin = null
  reset = null
  emitreset = null
  cout = null
  loader = null
  before ->
    loader = new noflo.ComponentLoader baseDir
  beforeEach (done) ->
    @timeout 4000
    loader.load 'math/Accumulate', (err, instance) ->
      return done err if err
      c = instance
      cin = noflo.internalSocket.createSocket()
      reset = noflo.internalSocket.createSocket()
      emitreset = noflo.internalSocket.createSocket()
      cout = noflo.internalSocket.createSocket()
      c.inPorts.in.attach cin
      c.inPorts.reset.attach reset
      c.inPorts.emitreset.attach emitreset
      c.outPorts.out.attach cout
      done()

  describe 'when instantiated', ->
    it 'should accumulate number', (done) ->
      cout.once 'data', (res) ->
        chai.expect(res).to.equal 2
        cout.once 'data', (res) ->
          chai.expect(res).to.equal 7
          cout.once 'data', (res) ->
            chai.expect(res).to.equal 10
            done()
      cin.send 2
      cin.send 5
      cin.send 3
    it 'should emit 0 when emitreset is set', (done) ->
      emitreset.send true
      emitreset.disconnect()

      cout.once 'data', (res) ->
        chai.expect(res).to.equal 4
        cout.once 'data', (res) ->
          chai.expect(res).to.equal 6
          cout.once 'data', (res) ->
            chai.expect(res).to.equal 0
            done()
      cin.send 4
      cin.send 2
      reset.send true
