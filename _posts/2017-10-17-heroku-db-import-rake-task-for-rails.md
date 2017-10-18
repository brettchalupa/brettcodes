---
layout: post
title: A Simple Rake Task for Importing Heroku Postgres Databases Locally for Rails Apps
date: 2017-10-17 17:00 PDT
author: Brett Chalupa
category: Ruby on Rails
tags: Heroku, Rake, Postgres
description: A quick way to download and ingest Heroku databases into the development environment.
comments: true
---

Over the years that I’ve been working with Ruby on Rails applications hosted on Heroku, I’ve regularly needed to import the database from Heroku into my local development environment. You may want to import a Heroku database locally to replicate and fix an issue or to quickly set up a non-trivial amount of data for development.

To do this, you would need to do the following steps:

1. Create the database back-up on Heroku
2. Download the database dump
3. Import that database dump locally
4. Migrate the database

Each of those steps requires a different command, which I can never memorize. In the past, I’ve created shell scripts to the run all of the commands, but I recently had the idea 💡 to create a Rake task that is easy to memorize and better fits within the paradigms of a Rails app. That task is `bin/rake db:import:production`. It’s easy enough to create a different task for each environment, like `bin/rake db:import:staging`. You could use a command flag to specify the environment, but I like doing it as part of the task name.

Here’s the annotated source for the Rake task:

``` ruby
# lib/tasks/db_import.rake
namespace :db do
  namespace :import do
    desc 'Import Heroku Staging database locally'
    task :staging do
      import_db('staging', 'YOUR_STAGING_HEROKU_APP_HERE')
    end

    desc 'Import Heroku Production database locally'
    task :production do
      import_db('production', 'YOUR_PRODUCTION_HEROKU_APP_HERE')
    end

    # Creates a unique database dump based on the current time and specified environment.
    def import_db(environment, heroku_app_name)
      puts("Importing #{environment} database locally...")
      file = "tmp/#{environment}-#{date}.dump"
      dump_local
      capture_and_download_heroku_db(heroku_app_name)
      `mv latest.dump #{file}`
      import_locally(file)
      run_migrations
      puts("#{environment} database successfully imported")
    end

    # Returns the readable date in YYYY-MM-DD with an
    # appended integer time to make the filename unique.
    def date
      "#{Time.now.to_date.to_s}-#{Time.now.to_i}"
    end

    # Returns the current machine's user for use with PG commands
    def user
      `whoami`.strip
    end

    # Creates and downloads a Heroku database back-up.
    # Requires the Heroku toolchain to be installed and setup.
    def capture_and_download_heroku_db(app)
      `heroku pg:backups:capture --app #{app}`
      `heroku pg:backups:download --app #{app}`
    end

    # Creates a back-up of your current local development
    # database in case you want to restore it.
    def dump_local
      `pg_dump -Fc --no-acl --no-owner -h localhost -U #{user} launchpad_api_development > tmp/development-#{date}.dump`
    end

    # Imports the downloaded database dump into your local development database.
    def import_locally(file)
      `pg_restore --verbose --clean --no-acl --no-owner -h localhost -U #{user} -d YOUR_LOCAL_DB_NAME_HERE #{file}`
    end

    # Runs migrations against the just imported database dump from Heroku.
    def run_migrations
      `bin/rake db:migrate`
    end
  end
end
```

As you can see above, this defines the two previously mentioned Rake tasks `bin/rake db:import:staging` and `bin/rake db:import:production`.  I broke down the various steps into descriptive methods for easy reference.

The task handles downloading and importing the Heroku database for the specified app environment, as well as backing up your local database in case you want to restore it at some point. All of the databases get downloaded to the `tmp` directory so that they don’t get tracked by Git. Be aware that if you clear out that directory, those database dumps will get deleted.

To add the tasks to your own app, you’ll need to make the following changes:

- Specify the environments and Heroku app names for your own apps
- Update the `-d` flag in the `#import_locally` method to be the name of your local database. If your app is called `Foo`, it’s likely the local development database is called `foo_development`.

You may also need to tweak the `#dump_local` and `#import_locally` methods based on your machine’s Postgres setup. At the time of publishing this post, the commands are for the default Postgres 9.6.5 setup on macOS 10.12 with Rails 5.1.4. 

The benefits of using Rake instead of a shell script is that if another developer (or yourself) runs `bin/rake -T` to see what Rake tasks are available, these would be incldude. Awesome! That increases the visibility of the tasks. Plus, by using the `db` namespace, it fits with the other tasks like `bin/rake db:migrate` so that it is hopefully easier to remember.

I hope this Rake task is useful for quickly downloading and importing Heroku databases into your Rails apps. Modifying it for your own app's needs should be straightforward enough. Let me know if you run into any issues or have any questions!

---

Additional resources:

- [The code on GitHub Gist](https://gist.github.com/brettchalupa/d1ed9507ce30fd963cb05258e6220509)
- [Importing and Exporting Heroku Postgres Databases with PG Backups - Heroku Dev Center](https://devcenter.heroku.com/articles/heroku-postgres-import-export)
