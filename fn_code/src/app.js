const express = require('express')
const bodyParser = require('body-parser')
const awsServerlessExpressMiddleware = require('aws-serverless-express/middleware')
const utils = require('./utilities')

// declare a new express app
const app = express()
app.use(bodyParser.json())
app.use(awsServerlessExpressMiddleware.eventContext())

// Enable CORS for all methods
app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*")
  res.header("Access-Control-Allow-Headers", "*")
  next()
});


app.post('/inbound/:provider', function(req, res) {
  console.log(`Inbound event from ${req.params.provider}`)
  // let normalized_event = {}
  // switch (req.params.provider.toLowerCase()) {
  //   case 'github':
  //     normalized_event = utils.normalize_github(req.body)
  //     break
  //   case 'gitlab':
  //     normalized_event = utils.normalize_gitlab(req.body)
  //     break
  //   default:
  //     res.status(404).json({msg: 'unknown provider'})
  //     return
  // }
  console.log(req.body)
  let repo_id = req.params.provider.toLocaleLowerCase() == "github" ? req.body.repository.id : req.body.pipeline_id
  utils.publish_mqtt(`${req.params.provider.toLocaleLowerCase()}/${repo_id}`,JSON.stringify(req.body))
    res.json({})
});

module.exports = app
