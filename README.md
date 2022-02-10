# Rails Engine Project: Turing 2110 BE Mod 3

## About

The Rails Engine project is a solo project that requires students to build a locally-served API in Ruby on Rails. The API serves information about a fictitious e-commerce system, with merchants who sell items, a many-to-many relationship between items and invoices, and also customer objects.

## Learning Goals 

- Expose an API 
- Use serializers to format JSON responses
- Test API exposure 
- Use SQL and AR to gather data

## Schema
Coming Soon!

## Requirements

* Ruby version 2.7.2
* Rails version 5.2.6

### Gems

* [rspec-rails](https://github.com/rspec/rspec-rails)
* [Pry](https://github.com/pry/pry)
* [Simplecov](https://github.com/simplecov-ruby/simplecov)
* [JSON:API Serializer](https://github.com/jsonapi-serializer/jsonapi-serializer)
* [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers)
* [Factory Bot](https://github.com/thoughtbot/factory_bot_rails)
* [Faker](https://github.com/faker-ruby/faker)

## Setup

Clone this repository to your local.

``` git clone git@github.com:hannahkwarren/rails-engine.git ```

Change to the project directory and run `bundle install`.

Create and set up your database: 
``` rails db:{drop,create,migrate,seed} ```

Start a local server with `rails s` and you can start making requests at localhost:3000! 

To run the test suite locally, `bundle exec rspec`. 
