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
    room_locks = locks[res.envelope.room] or {}

    name = res.match[1].trim()
    name_lower = name.toLowerCase()

    if name_lower of room_locks

      if room_locks[name_lower].user == res.envelope.user.id
        res.reply ":x: Nope, *#{name}* is already locked by you!"
      else
        res.reply ":x: Nope, *#{name}* is already locked by <@#{room_locks[name_lower].user}>"

      return

    lock = {}
    lock.user = res.envelope.user.id
    lock.name = name

    room_locks[name_lower] = lock
    locks[res.envelope.room] = room_locks

    robot.brain.set('locks', locks)

    res.reply ":lock: OK, locked *#{name}* for you"

  robot.respond /unlock (.*)/, (res) ->
    locks = robot.brain.get('locks') or {}
    room_locks = locks[res.envelope.room] or {}

    name = res.match[1].trim()
    name_lower = name.toLowerCase()

    if name_lower of room_locks

      if room_locks[name_lower].user == res.envelope.user.id
        delete room_locks[name_lower]
        robot.brain.set('locks', locks)

        res.reply ":unlock: Unlocked *#{name}*"
      else
        res.reply ":x: Nope, *#{name}* is locked by <@#{locks[name_lower].user}>"
    else
      res.reply "#{name} is not locked"

  robot.respond /list all locks/, (res) ->
    locks = robot.brain.get('locks') or {}
    room_locks = locks[res.envelope.room] or {}

    if Object.keys(room_locks).length == 0
      res.reply 'Nothing is locked, everything is allowed'
      return

    text = "Currently locked:"

    for name, lock of room_locks
      text += "\n:lock: *#{lock.name}* locked by <@#{lock.user}>"

    res.reply text

  robot.respond /delete all locks/, (res) ->
    locks = robot.brain.get('locks') or {}
    locks[res.envelope.room] = {}
    robot.brain.set('locks', locks)

    res.reply ':warning: Deleted all locks'
