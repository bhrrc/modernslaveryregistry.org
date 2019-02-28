# README

## Running locally

```
$ bundle
$ rails db:create
$ rails db:migrate
$ rails server
```

## Seeding the database

Before you can seed the database, there must be an admin user in the database.
Sign up using the sign-up form (`/signup`). Then use the console to make the user
an admin:

```
$ rails console
$ user = User.find_by_email('someone@somewhere.com')
$ user.admin = true
$ user.save
```

Then seed the database:

```
$ SEED_ADMIN_EMAIL=someone@somewhere.com no_fetch=true rails db:seed
```

## Deploying

We're using Elastic Beanstalk to host the app on AWS.

### Configure Elastic Beanstalk CLI

#### Prerequisites

1. AWS CLI (`brew install awscli`)
2. Elastic Beanstalk CLI (`brew install aws-elasticbeanstalk`)
3. Credentials (access and secret key) of an IAM user with admin permissions

#### Create an AWS profile

This creates a profile named "msr" that we'll use to configure the Elastic Beanstalk CLI.

```
$ aws configure --profile msr
AWS Access Key ID [None]: <your-access-key>
AWS Secret Access Key [None]: <your-secret-key>
Default region name [None]: eu-west-2
Default output format [None]:
```

#### Configure Elastic Beanstalk CLI

```
$ eb init \
  modern-slavery-registry \
  --profile="msr" \
  --region="eu-west-2" \
  --keyname="modern-slavery-registry"
Note: Elastic Beanstalk now supports AWS CodeCommit; a fully-managed source control service. To learn more, see Docs: https://aws.amazon.com/codecommit/
Do you wish to continue with CodeCommit? (y/N) (default is n): n
```

Where:

* `modern-slavery-registry` is the name of the application we have configured in Elastic Beanstalk.
* `profile="msr"` matches the name of the profile created above.
* `region="eu-west-2"` identifies the region the app has been deployed in.
* `keyname="modern-slavery-registry"` specifies the key pair to use when configuring the EC2 instances. Available key pairs can be found in the AWS web console > EC2  > Network & Security > Key Pairs.

#### Check that everything is working

This will show details about the current environment.

```
$ eb status
```

### Deploy the app

```
$ eb deploy
```

### Deploy the app using blue/green deployment

This deploys the app to a clone of the production environment (staging) to allow it to be tested before making it live.

```
$ export MSR_OLD_ENVIRONMENT=msr-production-green
$ export MSR_NEW_ENVIRONMENT=msr-production-blue

# Clone the environment
$ eb clone $MSR_OLD_ENVIRONMENT --clone_name $MSR_NEW_ENVIRONMENT --cname msr-staging

# Tell `eb` to use the new environment
$ eb use $MSR_NEW_ENVIRONMENT

# Deploy the latest version of the app
$ eb deploy

# Check that the site's working as expected
$ eb open

# Swap CNAMEs so that the live site points to the new environment
$ eb swap $MSR_OLD_ENVIRONMENT --destination_name $MSR_NEW_ENVIRONMENT

# Terminate old environment once enough time has passed to ensure DNS propagation
$ eb terminate $MSR_OLD_ENVIRONMENT
```

[eb-cli]: https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html

### SSH access to the EC2 instances

NOTE. This should be a last resort and hopefully not required given all the logging provided by Elastic Beanstalk.

Elastic Beanstalk adds the "modern-slavery-registry" key to the EC2 instances. You'll need the private part of this key from MSR in order to SSH into the boxes.

```
$ eb ssh
```

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
$ bundle exec rake db:structure:load

# Run the tests
$ bundle exec rake

# Make the site accessible from laptop on http://localhost:9292
$ PORT=9292 foreman start

# Optionally restore database backup from Heroku
$ pg_restore --no-owner --clean --if-exists --dbname="msaregistry_development" ./tmp/modern-slavery-db.pgdump
```

## Exporting original statements to local disk

Modify `config/environments/development` to use Amazon S3 for storage

```
config.active_storage.service = :amazon
```

Make sure you have AWS keys set in your environment (see `config/storage.yml` for details) and then run

```
$ bundle exec rails r script/export-statements-to-local-disk original-statements
```

## Extracting text from PDF statements

If you are not using the Vagrant VM, you will need to install the following [`Docsplit` dependencies](http://documentcloud.github.io/docsplit/#installation):

Linux:

```
apt-get install -y graphicsmagick
apt-get install -y poppler-utils poppler-data
apt-get install -y ghostscript
apt-get install -y tesseract-ocr
```

MacOS:

```
brew install graphicsmagick
brew install poppler
brew install ghostscript
brew install tesseract
```

To extract text from all PDF files in a directory:

```
$ cd original-statements && find . -name "*.pdf" -type f -print0 | xargs -I{} -0 bundle exec docsplit text "{}"
```
