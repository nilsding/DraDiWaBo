# DraDiWaBo

[![Build Status](https://semaphoreci.com/api/v1/nilsding/dradiwabo/branches/master/badge.svg)](https://semaphoreci.com/nilsding/dradiwabo)

This is a Telegram bot which periodically checks Bad Dragon's clearance
section for nice deals.  Or something like that.

## Installation

### Dependencies

* Crystal 0.26.1
* Redis
* `openssl-devel`

### Compiling

Since it's Crystal...

```sh
shards build
```

## Usage

Server side:

```sh
# set the telegram token in ENV
export TELEGRAM_API_TOKEN=some.token

# start the bot
./bin/DragonDickWatchbot start

# check the clearance section and notify interested users
./bin/DragonDickWatchbot notify

# start the workers which send the notifications to the users
./bin/DragonDickWatchbot worker -q send_notification,1 -q notify,1

# (optional) start a web UI to see the worker status
WEB_SESSION_SECRET=heast ./bin/DragonDickWatchbot web
```

Telegram side:

```
Start the bot:

  /start

Add a new toy to your watchlist:

  /addWatch nova extralarge
  
Remove a toy from your watchlist:

  /removeWatch nova small
  
Display a list of commands:

  /help
```

## Development

¯\\\_(ツ)\_/¯

## Contributing

1. Fork it (<https://github.com/nilsding/DraDiWaBo/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [nilsding](https://github.com/nilsding) Georg Gadinger - creator, maintainer
