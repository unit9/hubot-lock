Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/hubot-lock.coffee')

describe 'hubot-lock', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'locks unlocked asset', ->
    @room.user.say('alice', '@hubot lock Main.unity').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot lock Main.unity']
        ['hubot', '@alice :lock: OK, locked *Main.unity* for you']
      ]

  it 'does not allow double locking', ->
    @room.user.say('alice', '@hubot lock Main.unity').then =>
      @room.user.say('bob', '@hubot lock Main.unity').then =>
        expect(@room.messages).to.eql [
          ['alice', '@hubot lock Main.unity']
          ['hubot', '@alice :lock: OK, locked *Main.unity* for you']
          ['bob', '@hubot lock Main.unity']
          ['hubot', '@bob :x: Nope, *Main.unity* is already locked by <@alice>']
        ]

  it 'does not allow double locking by same user', ->
    @room.user.say('alice', '@hubot lock Main.unity').then =>
      @room.user.say('alice', '@hubot lock Main.unity').then =>
        expect(@room.messages).to.eql [
          ['alice', '@hubot lock Main.unity']
          ['hubot', '@alice :lock: OK, locked *Main.unity* for you']
          ['alice', '@hubot lock Main.unity']
          ['hubot', '@alice :x: Nope, *Main.unity* is already locked by you!']
        ]

  it 'unlocks locked asset', ->
    @room.user.say('alice', '@hubot lock Main.unity').then =>
      @room.user.say('alice', '@hubot unlock Main.unity').then =>
        @room.user.say('bob', '@hubot lock Main.unity').then =>
          expect(@room.messages).to.eql [
            ['alice', '@hubot lock Main.unity']
            ['hubot', '@alice :lock: OK, locked *Main.unity* for you']
            ['alice', '@hubot unlock Main.unity']
            ['hubot', '@alice :unlock: Unlocked *Main.unity*']
            ['bob', '@hubot lock Main.unity']
            ['hubot', '@bob :lock: OK, locked *Main.unity* for you']
          ]
