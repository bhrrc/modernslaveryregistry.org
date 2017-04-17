# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Running locally

    bundle
    rails db:create
    rails db:migrate
    rails server

## Importing data

Before you can import data, there must be an admin user in the database.
Sign up using the sign-up form. Then use the console to make the user
an admin:

    rails console
    user = User.find_by_email('someone@somewhere.com')
    user.admin = true
    user.save

Then seed the database:

    SEED_ADMIN_EMAIL=someone@somewhere.com no_verify_statement_urls=true rails db:seed

For production you should use:

    heroku rails db:seed # the env vars are already set
