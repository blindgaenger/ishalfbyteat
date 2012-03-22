# ishalfbyte.at

Checking out halfbyte's checkins.


## Setup

Install the heroku toolbelt

    https://toolbelt.heroku.com/

Add the heroku-config plugin to handle the environment variables

    heroku plugins:install git://github.com/ddollar/heroku-config.git

Copy `.env.example` as a template

    cp .env.example .env

Edit `.env` to add your oauth_token


## Development

Install the gems

    bundle install

Start a development server at http://localhost:3000

    bundle exec rake server


## Deployment

    bundle exec rake deploy
