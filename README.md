# hubot-lock

A hubot script for locking assets

See [`src/hubot-lock.coffee`](src/hubot-lock.coffee) for full documentation.

[![Build Status](https://travis-ci.org/unit9/hubot-lock.svg?branch=master)](https://travis-ci.org/unit9/hubot-lock)

## Installation

In hubot project repo, run:

`npm install hubot-lock --save`

Then add **hubot-lock** to your `external-scripts.json`:

```json
[
  "hubot-lock"
]
```

## Sample Interaction

```
alice>> @hubot lock Main.unity
hubot>> @alice :lock: OK, locked *Main.unity* for you
bob>> @hubot lock Main.unity
hubot>> @bob :x: Nope, *Main.unity* is already locked by <@alice>
```

## NPM Module

https://www.npmjs.com/package/hubot-lock
