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

## Seeding the database

Before you can seed the database, there must be an admin user in the database.
Sign up using the sign-up form (`/signup`). Then use the console to make the user
an admin:

    rails console
    user = User.find_by_email('someone@somewhere.com')
    user.admin = true
    user.save

Then seed the database. To disable (slow) verification of statement URLs,
set `no_verify_statement_urls=true`:

    SEED_ADMIN_EMAIL=someone@somewhere.com no_fetch=true rails db:seed

For production you should use:

    heroku run rails db:seed # the env vars are already set
