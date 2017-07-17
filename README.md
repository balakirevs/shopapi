# Rails API Shop.

## Setup

```
$ cd ~/workspace
$ git clone https://github.com/balakirevs/shopapi.git
$ cd shopapi
$ bundle install; touch tmp/restart.txt
$ bundle exec rake db:migrate
$ bundle exec rspec spec
$ brakeman
```
## To run parallel tests
```
$ bundle exec rake parallel:create
$ bundle exec rake parallel:prepare
$ bundle exec zeus start
$ bundle exec zeus parallel_rspec spec
```

## Pow
```
$ curl get.pow.cx | sh
$ cd ~/.pow
$ ln -s ~/workspace/shop_api
navigate to http://api.shop_api.dev
the credentials to access are admin for the username and sekret for the password
```

## To check endpoints
```
$ curl -H 'Accept: application/vnd.shop_api.v1' http://api.shop_api.dev/users/1 
navigate to http://shopapi.dev/sabisu_rails/explorer
```
