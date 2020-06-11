# README

This is the Rails app behind the [Modern Slavery Registry](https://www.modernslaveryregistry.org/).

---

## Developing

The easiest way to start developing is to use the [Vagrant](https://www.vagrantup.com/) virtual machine. This includes everything required to get the app running locally.

```shell
# On the host machine
$ vagrant up
$ vagrant ssh

# On the Vagrant VM
$ cd /vagrant/
$ bundle install
$ bundle exec rake db:setup

# Run the tests
$ bundle exec rake

# Make the site accessible from laptop on http://localhost:9292
$ PORT=9292 foreman start
```

*** Ensure that the bundler version is in sync between your local env, ci, AWS EB (currently 2.0.2) ***

### Seeding the database

The database should have been seeded as part of the `rake db:setup` step. It seeds enough of the database to pass specs, allow the app to launch, and includes some "static" tables (that don't change too much), including:

- CallToActions
- Countries
- Industries
- Legislations
- Pages

An administrator account is created during seeding:

- email: `admin@example.com`
- password: `password`

There's also a rake task to make any user an admin. Pass the user's email address to the rake task as a string in an array:

```shell
# On the Vagrant VM
$ rake user:make_admin["someone@somewhere.com"]
```

Other tables, like Companies, Statement, Snapshots, etc., have dependencies (like ARStorage, HABTM relationships, etc.) or do not have corresponding Rails models that make seeding difficult and error-prone.

For effective local development, the full data should be imported from a dump of the staging or production databases. See "Download and import production data", below.

---

## Deploying

We're using Elastic Beanstalk to manage the app on AWS.

### Configure Elastic Beanstalk CLI

#### Prerequisites

1. AWS CLI (`brew install awscli`)
2. Elastic Beanstalk CLI (`brew install aws-elasticbeanstalk`)
3. Credentials (access and secret key) of an IAM user with admin permissions

#### Create an AWS profile

This creates a profile named "msr" that we'll use to configure the Elastic Beanstalk CLI.

```shell
$ aws configure --profile msr
AWS Access Key ID [None]: <your-access-key>
AWS Secret Access Key [None]: <your-secret-key>
Default region name [None]: eu-west-2
Default output format [None]:
```

#### Configure Elastic Beanstalk CLI

```shell
$ eb init \
  modern-slavery-registry \
  --profile="msr" \
  --region="eu-west-2" \
  --keyname="modern-slavery-registry"
Note: Elastic Beanstalk now supports AWS CodeCommit; a fully-managed source control service. To learn more, see Docs: https://aws.amazon.com/codecommit/
Do you wish to continue with CodeCommit? (y/N) (default is n): n
```

Where:

- `modern-slavery-registry` is the name of the application we have configured in Elastic Beanstalk.
- `profile="msr"` matches the name of the profile created above.
- `region="eu-west-2"` identifies the region the app has been deployed in.
- `keyname="modern-slavery-registry"` specifies the key pair to use when configuring the EC2 instances. Available key pairs can be found in the AWS web console > EC2 > Network & Security > Key Pairs.

#### Check that everything is working

This will show details about the current environment.

```shell
$ eb status
```

### Deploy the app

```shell
$ eb deploy
```

### Deploy the app using blue/green deployment

This deploys the app to a clone of the production environment (staging) to allow it to be tested before making it live.

```shell
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

---

### Elasticsearch Reindexing

The reindexing process is divided into two stages:

* Common search data reindexing:

`bindle exec rake search:reindex`

* Statements content reindexing to enable search by keywords:

`bundle exec rake search:extract_statements`

## Debugging production problems

### View EC2 instance health

See the [Instance Metrics documentation](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/health-enhanced-metrics.html) for help understanding the output of this command.

```shell
$ eb health
```

### View Rails application logs

#### For a single active instance.

```shell
$ eb ssh
$ cd /var/app/current/
$ less log/production.log
```

#### For all instances in all environments.

The production logs from the Rails app are uploaded to S3 hourly.

The logs are available at /resources/environments/logs/publish/<elastic-beanstalk-environment-id>/<ec2-instance-id> in a bucket named "elasticbeanstalk-eu-west-2-<aws-account-id>".

Find the current Elastic Beanstalk environment ID by running `eb status` and find the individual EC2 instance IDs by running `eb health`.

### SSH access to the EC2 instances

NOTE. This should be a last resort and hopefully not required given all the logging provided by Elastic Beanstalk.

Elastic Beanstalk adds the "modern-slavery-registry" key to the EC2 instances. You'll need the private part of this key from MSR in order to SSH into the boxes.

```shell
$ eb ssh
```

---

## Using production data in development

NOTE. The version of the PostgreSQL client on the EC2 instances (9.2) doesn't match the version of PostgreSQL on RDS (11) so we need to upgrade the client tools before we can create a backup.

### Update PostgreSQL client on EC2 instances

Run `psql --version` on the EC2 instance to print the current version. If it's not 11 you need to upgrade it.

```shell
# Search for installed postgresql tools
$ rpm --query --all | grep postgresql
postgresql92-devel-9.2.24-2.66.amzn1.x86_64
postgresql92-libs-9.2.24-2.66.amzn1.x86_64
postgresql92-9.2.24-2.66.amzn1.x86_64

# Remove postgresql 9.2
$ sudo rpm --erase postgresql92-devel postgresql92-libs postgresql92

# Install postgresql 11
$ sudo yum install -y https://download.postgresql.org/pub/repos/yum/11/redhat/rhel-6-x86_64/postgresql11-libs-11.4-1PGDG.rhel6.x86_64.rpm
$ sudo yum install -y https://download.postgresql.org/pub/repos/yum/11/redhat/rhel-6-x86_64/postgresql11-11.4-1PGDG.rhel6.x86_64.rpm
```

### Download and import production data

```shell
# SSH to EC2 instance
development$ eb ssh

# Print database details (these are in the format postgres://<username>:<password>@<host>/<dbname>)
ec2$ echo $DATABASE_URL

# Create database backup
ec2$ export MSR_DB_DUMP_FILENAME="`date -u "+%Y%m%dT%H%M%SZ"`-msr.sql"
ec2$ pg_dump --host="<host>" --username="<username>" --dbname="<dbname>" > ~/$MSR_DB_DUMP_FILENAME
ec2$ echo "File written to ~/$MSR_DB_DUMP_FILENAME"

# Make a note of the SSH connection options from when the session first opened
# INFO: SSH port 22 open.
# INFO: Running ssh -i /path/to/modern-slavery-registry.pem ec2-user@<ec2-ip-address>

# Download database backup
development$ scp -i /path/to/modern-slavery-registry.pem ec2-user@<ec2-ip-address>:<msr-db-dump-filename> ./tmp

# Restore database backup
development$ rake db:drop db:create
development$ psql --dbname="msaregistry_development" --file=./tmp/<msr-db-dump-filename>
```

---

## Exporting original statements to local disk

Modify `config/environments/development` to use Amazon S3 for storage

```ruby
config.active_storage.service = :amazon
```

Make sure you have AWS keys set in your environment (see `config/storage.yml` for details) and then run

```shell
$ bundle exec rails r script/export-statements-to-local-disk original-statements
```

---

## Extracting text from PDF statements

If you are not using the Vagrant VM, you will need to install the following [`Docsplit` dependencies](http://documentcloud.github.io/docsplit/#installation):

Linux:

```shell
$ apt-get install -y graphicsmagick
$ apt-get install -y poppler-utils poppler-data
$ apt-get install -y ghostscript
$ apt-get install -y tesseract-ocr
```

MacOS:

```shell
$ brew install graphicsmagick
$ brew install poppler
$ brew install ghostscript
$ brew install tesseract
```

To extract text from all PDF files in a directory:

```shell
$ cd original-statements && find . -name "*.pdf" -type f -print0 | xargs -I{} -0 bundle exec docsplit text "{}"
```

---

## Production environment

### Infrastructure

- AWS Elastic Beanstalk to host Rails app

- AWS RDS PostgreSQL database

- AWS S3 for statement snapshots

- AWS ElastiCache Redis for Sidekiq

- AWS Certificate Manager for SSL certificate

- Sendgrid for sending emails

- Rollbar for catching exceptions

### Environment variables

- `DATABASE_URL`

  - Manually set using credentials used to create the RDS instance, and using values from the RDS web interface (in the format "postgres://<username>:<password>@<endpoint>/<database-name>")

- `RAILS_MAX_THREADS`

  - Manually set to 32 to match the maximum number of threads set in the Elastic Beanstalk Puma config (in /opt/elasticbeanstalk/support/conf/pumaconf.rb)

- `ACTIVE_STORAGE_S3_BUCKET_NAME` and `ACTIVE_STORAGE_S3_BUCKET_REGION`

  - Manually set to the S3 bucket name and region used for storing and serving statement snapshots

- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`

  - Manually set to the AWS credentials of an IAM user with access to read/write objects in the S3 bucket above

- `SENDGRID_USERNAME` and `SENDGRID_PASSWORD`

  - Manually set to the username and password of our Sendgrid account

- `ROLLBAR_ACCESS_TOKEN`

  - Manually set to the value of the `post_server_item` token in the Rollbar web interface

- `REDIS_URL`

  - Manually set using the endpoint and port in the ElastiCache web console (in the format "redis://<redis-url>:6379")

- `SECRET_KEY_BASE`

  - Manually set to the output of running `rails secret`

- `BUNDLE_WITHOUT`, `RACK_ENV`, `RAILS_SKIP_ASSET_COMPILATION` and `RAILS_SKIP_MIGRATIONS`
  - Set by default in the Elastic Beanstalk Ruby platform
