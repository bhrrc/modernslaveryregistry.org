# README

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

## Developing using Vagrant

```
# On the host machine
$ vagrant up
$ vagrant ssh

# On the Vagrant VM
$ cd /vagrant/
$ bundle install
$ bundle exec rake db:create
$ bin/rails db:environment:set RAILS_ENV=development
$ bundle exec rake db:schema:load

# Run the tests
$ bundle exec rake

# Make the site accessible from laptop on http://localhost:9292
$ PORT=9292 foreman start

# Optionally restore database backup from Heroku
$ pg_restore --no-owner --clean --if-exists --dbname="msaregistry_development" ./tmp/modern-slavery-db.pgdump
```
