noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai'
  path = require 'path'
  baseDir = path.resolve __dirname, '../'
else
  baseDir = 'noflo-math'

describe 'Absolute Value component', ->
  c = null
  value = null
  modulus = null
  before (done) ->
    @timeout 4000
    loader = new noflo.ComponentLoader baseDir
    loader.load 'math/AbsoluteValue', (err, instance) ->
      return done err if err
      c = instance
      value = noflo.internalSocket.createSocket()
      c.inPorts.value.attach value
      done()
  beforeEach ->
    modulus = noflo.internalSocket.createSocket()
    c.outPorts.modulus.attach modulus
  afterEach ->
    c.outPorts.modulus.attach modulus
    modulus = null

  describe 'when instantiated', ->
    it 'should not hold values', ->
      chai.expect(c.primary).to.be.an 'object'
      chai.expect(c.primary.value).to.be.a 'null'
      chai.expect(c.secondary).to.be.a 'null'
    it 'should calculate the absolute value of -5 = 5', (done) ->
      modulus.once 'data', (res) ->
        chai.expect(res).to.equal 5
        done()
      base.send -5
