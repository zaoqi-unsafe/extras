'use strict'

const
  filename = process.argv[2]
, zmq      = require('zmq')
, req      = zmq.socket('req')

req.on('message', (data) => {
  let rep = JSON.parse(data)
  console.log('response:', rep)
})
req.connect('tcp://localhost:5433')
console.log('requesting ' + filename)
req.send(JSON.stringify({path : filename}))
