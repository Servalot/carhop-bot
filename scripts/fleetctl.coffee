# Description:
#   Manages all of the Servalot service connections to our clusters.
#
# Commands: carhop deploy <service> - Deploys the latest build of the service to
# the cluster. carhop stop <service> - Stop the service in the cluster. what is
# <state> - Ask carhop what is <running|dead|inactive>. status report - Gives a
# cluster status report.
#
# URLS:
#   /carhop/help
#
# Notes:
#   These commands are grabbed from comment blocks at the top of each file.
module.exports = (robot) ->
  Fleetctl = require("fleetctl")
  fleetctl = new Fleetctl(binary: "bin/fleetctl_wrapper.sh")
  robot.respond /deploy (.*)/i, (res) ->
	  service = res.match[1]
	  res.reply "Deploying '#{service}', please wait.."

	  start_service = (err) ->
		  if err
			  res.reply "Error starting '#{service}' service. \n```#{err}```"
			  throw err
		  else
			  res.reply "Started '#{service}'"
			  res.reply "Deploy of '#{service}' complete."

	  stop_service = (err) ->
		  if err
			  res.reply "Error stopping '#{service}' service. \n```#{err}```"
			  throw err
		  else
			  res.reply "Stopped '#{service}', waiting 2 sec to restart service.."
			  sleep(2000)
			  fleetctl.start service, "-no-block=false", start_service

	  fleetctl.stop service, "-no-block=false", stop_service


  robot.respond /stop (.*)/i, (res) ->
	  service = res.match[1]

	  stop_service = (err) ->
		  if err
			  res.reply "Error stopping '#{service}' service. \n```#{err}```"
			  throw err
		  else
			  res.reply "Stopped '#{service}'" if !err?

	  fleetctl.stop service, "-no-block=false", stop_service

  robot.hear /what is (.*)/i, (res) ->
	  state = res.match[1]
	  unit_list = (err, units) ->
		  if (err)
			  throw err
		  out = for unit in units when unit.sub == state
			  unit.unit
		  res.send "```#{out.join("\n")}```"
	  fleetctl.list_units unit_list

  robot.hear /status report/i, (res) ->
	  unit_list = (err, units) ->
		  if (err)
			  throw err
		  out = for unit in units
		    "#{unit.unit} - #{unit.sub}"
		  res.send "```#{out.join("\n")}```"
	  fleetctl.list_units unit_list


  sleep = (ms) ->
    start = new Date().getTime()
    continue while new Date().getTime() - start < ms
