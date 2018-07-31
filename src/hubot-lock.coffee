# Description
#   A hubot script for locking assets
#
# Configuration:
#
# Commands:
#
# Notes:
#
# Author:
#   Krzysztof Skoracki <krzysztof.skoracki@unit9.com>

module.exports = (robot) ->
  robot.respond /lock (.*)/, (res) ->
    locks = robot.brain.get('locks') or {}

    name = res.match[1].trim()
    name_lower = name.toLowerCase()

    if name_lower of locks

      if locks[name_lower].user == res.envelope.user.id
        res.reply ":x: Nope, *#{name}* is already locked by you!"
      else
        res.reply ":x: Nope, *#{name}* is already locked by <@#{locks[name_lower].user}>"

      return

    lock = {}
    lock.user = res.envelope.user.id
    lock.name = name

    locks[name_lower] = lock

    robot.brain.set('locks', locks)

    res.reply ":lock: OK, locked *#{name}* for you"

  robot.respond /unlock (.*)/, (res) ->
    locks = robot.brain.get('locks') or {}

    name = res.match[1].trim()
    name_lower = name.toLowerCase()

    if name_lower of locks

      if locks[name_lower].user == res.envelope.user.id
        delete locks[name_lower]
        robot.brain.set('locks', locks)

        res.reply ":unlock: Unlocked *#{name}*"
      else
        res.reply ":x: Nope, *#{name}* is locked by <@#{locks[name_lower].user}>"
    else
      res.reply "#{name} is not locked"

  robot.respond /list all locks/, (res) ->
    locks = robot.brain.get('locks') or {}

    if Object.keys(locks).length == 0
      res.reply 'Nothing is locked, everything is allowed'
      return

    text = "Currently locked:"

    for name, lock of locks
      text += "\n:lock: *#{lock.name}* locked by <@#{lock.user}>"

    res.reply text

  robot.respond /delete all locks/, (res) ->
    robot.brain.set('locks', {})

    res.reply ':warning: Deleted all locks'
