# Description:
#   Manages all of the Servalot service connections to our clusters.
#
# Commands:
#   carhop deploy <service> - Deploys the latest build of the service to the cluster.
#   carhop stop <service> - Stop the service in the cluster.
#   what is <state> - Ask carhop what is <running|dead|inactive>.
#   status report - Gives a cluster status report.
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
	  
	  stop_service = (err) ->
  		  if err
  		    res.reply "Error stopping '#{service}' service. \n```#{err}```"
  		    throw err
		  res.reply "Stopped '#{service}'" if !err?
		  fleetctl.start service, "-no-block=false", start_service
	  

	  start_service = (err) ->
  		  if err
  		    res.reply "Error starting '#{service}' service. \n```#{err}```"
  		    throw err 
		  res.reply "Started '#{service}'" if !err?
	 
	  fleetctl.stop service, "-no-block=false", stop_service
	  

  robot.respond /stop (.*)/i, (res) ->
	  service = res.match[1]
	  
	  stop_service = (err) ->
  		  if err
  		    res.reply "Error stopping '#{service}' service. \n```#{err}```"
  		    throw err
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
  # robot.hear /badger/i, (res) ->
  #   res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"
  #
  # robot.respond /open the (.*) doors/i, (res) ->
  #   doorType = res.match[1]
  #   if doorType is "pod bay"
  #     res.reply "I'm afraid I can't let you do that."
  #   else
  #     res.reply "Opening #{doorType} doors"
  #
  # robot.hear /I like pie/i, (res) ->
  #   res.emote "makes a freshly baked pie"
  #
  # lulz = ['lol', 'rofl', 'lmao']
  #
  # robot.respond /lulz/i, (res) ->
  #   res.send res.random lulz
  #
  # robot.topic (res) ->
  #   res.send "#{res.message.text}? That's a Paddlin'"
  #
  #
  # enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
  # leaveReplies = ['Are you still there?', 'Target lost', 'Searching']
  #
  # robot.enter (res) ->
  #   res.send res.random enterReplies
  # robot.leave (res) ->
  #   res.send res.random leaveReplies
  #
  # answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING
  #
  # robot.respond /what is the answer to the ultimate question of life/, (res) ->
  #   unless answer?
  #     res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
  #     return
  #   res.send "#{answer}, but what is the question?"
  #
  # robot.respond /you are a little slow/, (res) ->
  #   setTimeout () ->
  #     res.send "Who you calling 'slow'?"
  #   , 60 * 1000
  #
  # annoyIntervalId = null
  #
  # robot.respond /annoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #     return
  #
  #   res.send "Hey, want to hear the most annoying sound in the world?"
  #   annoyIntervalId = setInterval () ->
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #   , 1000
  #
  # robot.respond /unannoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "GUYS, GUYS, GUYS!"
  #     clearInterval(annoyIntervalId)
  #     annoyIntervalId = null
  #   else
  #     res.send "Not annoying you right now, am I?"
  #
  #
  # robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
  #   room   = req.params.room
  #   data   = JSON.parse req.body.payload
  #   secret = data.secret
  #
  #   robot.messageRoom room, "I have a secret: #{secret}"
  #
  #   res.send 'OK'
  #
  # robot.error (err, res) ->
  #   robot.logger.error "DOES NOT COMPUTE"
  #
  #   if res?
  #     res.reply "DOES NOT COMPUTE"
  #
  # robot.respond /have a soda/i, (res) ->
  #   # Get number of sodas had (coerced to a number).
  #   sodasHad = robot.brain.get('totalSodas') * 1 or 0
  #
  #   if sodasHad > 4
  #     res.reply "I'm too fizzy.."
  #
  #   else
  #     res.reply 'Sure!'
  #
  #     robot.brain.set 'totalSodas', sodasHad+1
  #
  # robot.respond /sleep it off/i, (res) ->
  #   robot.brain.set 'totalSodas', 0
  #   res.reply 'zzzzz'
