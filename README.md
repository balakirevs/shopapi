# Rails 5 API Shop

## Setup

```
$ cd ~/workspace
$ git clone https://github.com/balakirevs/shopapi.git
$ cd shopapi
$ bundle install
$ bundle exec rails db:setup
$ bundle exec rspec spec
$ brakeman
```
## To run parallel tests
```
$ bundle exec rails parallel:create
$ bundle exec rails parallel:prepare
$ bundle exec zeus start
$ bundle exec zeus parallel_rspec spec
```

## Pow
```
$ curl get.pow.cx | sh
$ cd ~/.pow
$ ln -s ~/workspace/shop_api
navigate to http://api.shop_api.dev
```

## To check endpoints
```
$ curl -H 'Accept: application/vnd.shop_api.v1' http://api.shop_api.dev/users/1 
```
