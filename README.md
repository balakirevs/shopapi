# Rails API Shop.

## Setup

```
$ cd ~/workspace
$ git clone https://github.com/balakirevs/shopapi.git
$ cd shopapi
$ bundle install
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