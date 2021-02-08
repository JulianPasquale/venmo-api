# VENMO

[Venmo](https://venmo.com/) is a mobile payment service which allows friends to transfer money to each other. 

# Getting started

## Dependencies

To be able to run this project, you will need:
- PostgreSQL.
- Ruby 2.7.2.
- Bundler gem.

## Instructions
1. Clone this repository.
1. Install PostgreSQL in case you don't have it.
1. Configure your environment variables creating a `.env` file.
    - You'll find a `.env.sample` with a sample configuration.
1. Run `bundle install`.
1. Create and migrate your database.
    - Run  `rails db:create db:migrate`
    - Optional: You can also run `rails db:seed` to get some sample data.
1. That's it! You can start the server with `rails s` command.

# Getting started with Docker

## Dependencies

To be able to run this project with Docker, you will need to have:
- Docker.
- PostgreSQL.

## Instructions
1. Clone this repository.
1. Install PostgreSQL in case you don't have it.
1. Configure your environment variables creating a `.env` file.
    - You'll find a `.env.sample` with a sample configuration.
    - If you set `MIGRATE=true`, your database will be automatically created and migrated.
    - If you set `SEED=true`, your database will be initialized with some sample data automatically.
1. Build the image:
    - ```sh
      $ docker build -t venmo .
      ```
1. Run the container:
    - ```sh
      $ docker run -p 3000:3000 --env-file=.env -it venmo
      ```

**Note:** You can also use Docker to run the tests.
```sh
$ docker run -p 3000:3000 --env-file=.env -it venmo rspec
```

# Getting started with Docker Compose

## Dependencies

To be able to run this project with Docker Compose, you only need to have Docker and Docker Compose installed in your computer!

## Instructions
1. Clone this repository.
1. Configure your environment variables creating a `.env` file.
    - You'll find a `.env.sample` with a sample configuration. Notice that not all the configurations are mandatory.
    - If you set `MIGRATE=true`, your database will be automatically created and migrated.
    - If you set `SEED=true`, your database will be initialized with some sample data automatically.
1. Build the image:
    - ```sh
      $ docker-compose build
      ```
1. Run the container:
    - ```sh
      $ docker-compose up
      ```

# Testing

This project includes some models and services unit tests.

You can run the tests with the following command:
```sh
$ rspec # or bundle exec rspec
```

# Code quality

This app follows the community best practices and standars of security and mantainability.

To run the code analysis tools you can run the command:
```sh
$ bundle exec rake code_analysis
```

# Gems
- [dotenv-rails](https://github.com/bkeepers/dotenv) to manage environment variables from `.env` files.
- [faker](https://github.com/faker-ruby/faker) for fake data generation for tests and seeds.
- [interactor](https://github.com/collectiveidea/interactor) to encapsulate the application's [business logic](http://en.wikipedia.org/wiki/Business_logic).
- [kaminari](https://github.com/kaminari/kaminari) for pagination.
- [pg](https://github.com/ged/ruby-pg) for connection with PostgreSQL database.
- [puma](https://github.com/puma/puma) for the run server.

### Code quality gems
- [brakeman](https://github.com/presidentbeef/brakeman)
- [rails_best_practices](https://github.com/flyerhzm/rails_best_practices)
- [reek](https://github.com/troessner/reek)
- [rubocop](https://github.com/rubocop-hq/rubocop)
- [rubocop-rails](https://github.com/rubocop-hq/rubocop-rails)
- [rubocop-rspec](https://github.com/rubocop-hq/rubocop-rspec)

### Testing gems
- [rspec-rails](https://github.com/rspec/rspec-rails)
- [factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails)
- [shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)
- [simplecov](https://github.com/simplecov-ruby/simplecov)

# Additional documentation

To get more information about the project, models and business rules, please check the [wiki](https://github.com/JulianPasquale/venmo-api/wiki) docs!

There you will find some API documentation, diagrams and a [Postman](https://www.postman.com/) collection to download.
