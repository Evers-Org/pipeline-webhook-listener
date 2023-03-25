const { IoTDataPlaneClient, PublishCommand } = require("@aws-sdk/client-iot-data-plane")

const normalize_github = (event) => {
  let body = JSON.parse(event.body)
  return {
    provider: 'GitHub',
    id: body.hasOwnProperty('workflow_run') ? body.workflow_run.id : body.workflow_job.id,
    provider_icon: 'https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png',
    repo: {
      url: body.repository.html_url,
      name: body.repository.full_name,
      id: body.repository.id,
    },
    event_type: body.hasOwnProperty('workflow_run') ? 'pipeline' : 'step',
    status: body.workflow && body.workflow.state,
    status_detail: body.hasOwnProperty('workflow_run') ? body.workflow_run.status : body.workflow_job.status,
    conclusion: body.hasOwnProperty('workflow_run') ? body.workflow_run.conclusion : body.workflow_job.conclusion,
    parent: body.hasOwnProperty('workflow_run') ? 0 : body.wor.run_id,
  }
}
const normalize_gitlab = (event) => {
  let body = JSON.parse(event.body)
  return {
    provider: 'GitLab',
    id: body.pipeline_id,
    provider_icon: 'https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png',
    repo: {
      url: body.homepage,
      name: body.name,
      id: body.project_id,
    },
    event_type: body.object_type == 'pipeline' ? 'pipeline' : 'step',
    status: body.build_status,
    status_detail: 'n/a',
    conclusion: build_failure_reason,
    parent: 'n/a',
  }
}

const publish_mqtt = (topic,payload) => {
  console.log(`publishing to ${topic}`)
  const config = {} // https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/clients/client-iot-data-plane/interfaces/iotdataplaneclientresolvedconfig.html
  const input = {
    messageExpiry: 3600,
    payload,
    topic,
  } // https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/clients/client-iot-data-plane/interfaces/publishcommandinput.html
  const client = new IoTDataPlaneClient(config);
  const command = new PublishCommand(input);
  const response = client.send(command)
      .then(res => console.log('Publish successful',res))
      .catch(e => {
        console.error('Failed to publish message',topic,payload,e)
      })

}

module.exports = {
  normalize_github,
  normalize_gitlab,
  publish_mqtt,
}