# Description:
#   Manages all of the Servalot service connections to our clusters.
#
# Commands:
# hubot deploy <service> - Deploys the latest build of the service to the cluster.
# hubot stop <service> - Stop the service in the cluster.
# what is <state> - Ask carhop what is <running|dead|inactive>.
# status report - Gives a cluster status report.
#
# URLS:
#   /hubot/help
#
# Notes:
#   These commands are grabbed from comment blocks at the top of each file.
module.exports = (robot) ->
  Fleetctl = require("fleetctl")
  fleetctl = new Fleetctl(binary: "bin/fleetctl_wrapper.sh")

  robot.respond /deploy (.*)/i, (res) ->
    service = res.match[1]
    msg = (value) ->
      res.send value

    deploy(service, msg)

  robot.respond /start (.*)/i, (res) ->
    service = res.match[1]
    msg = (value) ->
      res.send value

    start(service, msg)

  robot.respond /stop (.*)/i, (res) ->
    service = res.match[1]
    msg = (value) ->
      res.send value

    stop(service, msg)

  robot.hear /what is (.*)/i, (res) ->
    state = res.match[1]
    unit_list = (err, units) ->
      if (err)
        throw err
      out = for unit in units when unit.sub == state
        unit.unit
      res.send ">>>```#{out.join("\n")}```"
    fleetctl.list_units unit_list

  robot.hear /status report/i, (res) ->
    unit_list = (err, units) ->
      if (err)
        throw err
      out = for unit in units
        "#{unit.unit} - #{unit.sub}"
      res.send ">>>```#{out.join("\n")}```"
    fleetctl.list_units unit_list

  # the expected value of :room is going to vary by adapter, it might be a numeric id, name, token, or some other value
  robot.router.post "/#{robot.name}/fleetctl/:room", (req, res) ->
    room   = req.params.room
    data   = if req.body.payload? then JSON.parse req.body.payload else req.body
    service = data.service
    cmd = data.cmd
    msg = (value) ->
      robot.messageRoom room, value

    switch cmd
      when "deploy" then deploy(service, msg)
      when "stop" then stop(service, msg)
      when "start" then start(service, msg)
      else msg ">I got a invalid command '#{cmd}' for '#{service}', not doing anything."

    res.send 'OK'

  robot.router.get "/", (req, res) ->
    res.send 'BEEP'

##### HELPER FUNCTIONS #####

# Stop a service
  stop = (service, msg) ->
    stop_service = (err) ->
      if err
        msg ">>>Error stopping '#{service}' service. \n```#{err}```"
        throw err
      else
        msg ">>>Stopped '#{service}'" if !err?

    fleetctl.stop service, "-no-block=false", stop_service

  start = (service, msg) ->
    start_service = (err) ->
      if err
        msg ">>>Error starting '#{service}' service. \n```#{err}```"
        throw err
      else
        msg ">>>Started '#{service}'" if !err?

    fleetctl.start service, "-no-block=false", start_service

# Deploy a service
  deploy = (service, msg) ->
    msg ">>>Deploying '#{service}', please wait.."

    start_service = (err) ->
      if err
        msg ">>>Error starting '#{service}' service. \n```#{err}```"
        throw err
      else
        msg ">>>Started '#{service}'"
        msg ">>>Deploy of '#{service}' complete."

    stop_service = (err) ->
      if err
        msg ">>>Error stopping '#{service}' service. \n```#{err}```"
        throw err
      else
        msg ">>>Stopped '#{service}', waiting 2 sec to restart service.."
        sleep(2000)
        fleetctl.start service, "-no-block=false", start_service

    fleetctl.stop service, "-no-block=false", stop_service


### UTIL FUNCIONS ###
sleep = (ms) ->
  start = new Date().getTime()
  continue while new Date().getTime() - start < ms
