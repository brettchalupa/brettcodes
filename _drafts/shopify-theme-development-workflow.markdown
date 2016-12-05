---
title: Shopify Theme Development Workflow
date: 2016-09-15 12:00:00 -07:00
author: Brett Chalupa
categories:
- shopify
tags:
- note
- shopify
- workflow
- archived
description: A simple and effective workflow for building and maintaining Shopify
  themes.
---

I have been doing theme development on a few Shopify stores
recently, and I have come up with a workflow that has been working well.

You can watch a screencast of the workflow or keep on reading.

<iframe width="700" height="394"
src="https://www.youtube-nocookie.com/embed/1xWFsYmBoX0?rel=0&amp;showinfo=0"
frameborder="0" allowfullscreen></iframe>

## Requirements

I wanted Shopify development to be as close to my normal workflow as
possible, which meant:

### Use Editor of Choice

The easiest way to make changes to a Shopify theme is to make changes
directly in the Shopify admin.

![shopify-theme-editor.png](/uploads/shopify-theme-editor.png)

The theme editor is competent, but I prefer working in my editor of
choice (vim). The theme editor has no split views, which can
make it difficult to reference code in other files. There is also no
theme customization for the web editor. The comfort of a text editor you
enjoy using is quite nice.

### Track Theme Changes with Git

I value being able to track the changes to a codebase over time, so it
is important to be able to manage the theme's history with Git. It is
nice to be able to work with branches for experiments, use
[`git bisect`](https://git-scm.com/docs/git-bisect) to identify when
bugs were introduced, and revert changes as needed.

### Multiple Store Support

For non-trivial theme changes, it is not a great idea to make the
changes on the live site. I wanted a workflow to be able to easily
support pushing the theme changes up to a a test store for review
before making those changes live. This also allows more traditional
releases to the live site to be created.

## The Workflow

The workflow, simplified, is: manage the theme source locally by making
changes and committing those changes with Git while running a command
line tool to watch for changes and update the theme on the Shopify
store.

It is worth noting that this workflow makes use of the command line. It
is not anything too intensive, but being comfortable with common
commands will help.

The first step is to install and setup [Theme
Kit](http://themekit.cat/install/). Theme Kit is a cross-platform
command line tool for Shopify theme development. It is written in Go,
which means it has no external dependencies, like Ruby Shopify command
line too, and is fast. Follow the install and setup instructions to get
started. Once it is all setup, the `theme` command will be available in
the terminal.

As of writing this, the Theme Kit version is `v0.4.2`.

Next, create a directory to work with the theme: `mkdir
STORE-NAME-HERE`. This folder will be the location of the theme source
code and the working directory for the rest of the workflow. After the
theme is created, change into the directory: `cd STORE-NAME-HERE`.

Create a file called `config-example.yml` in the theme directory and add
the following to it:

~~~
development:
  store: example.myshopify.com
  password: add-password-in-config
  theme_id: "live"
  bucket_size: 40
  refill_rate: 2
  ignore_files:
    - "*.swp"
    - "*~"
    - "config/settings_data.json"
~~~

The configuration is used by Theme Kit to manage the different
store environment settings. An example file is used because it does not
contain secrets and can be checked into Git. Soon the config file with
the actual values will be setup.

The `theme_id` is set to `"live"` so that it makes changes to whatever
theme is currently live on the store. It can be changed to the id of a
specific theme on the store if needed.

If you are using Git, initialize the repository with `git init` and
create a `.gitignore` file with the following lines:

~~~
config.yml
config/settings_data.json
~~~

This will prevent secrets from the soon-to-be-created `config.yml` from
being checked in, as well as ignore `config/settings_data.json` which is
store-specific and does not need to be tracked by Git.

Now it is time to setup the actual configuration. Copy the config
example to the file Theme Kit will use: `cp config-example.yml
config.yml`.

Create a private app in your Shopify store, which will yield a password
to add to `config.yml`. I usually call the app "Theme Development -
Brett" so others know what the private app is for and who is using it.

Go ahead and set the store URL and password in `config.yml`.

The Theme Kit config is all set for development. Next up is to pull down
the theme from Shopify, which can be done with the `theme download`
command.

With the theme downloaded and the Git repository initialized, now is a
great time to create the first commit. Go ahead and add all the files
with `git add --all` and make a commit with `git commit`.

All that is left if to tell Theme Kit to watch for changes with the
`theme watch` command. Now change can be made to the theme and they will
automatically be pushed up to the store. Develop away and make Git
commits along the way.

## Multiple Environment Config

As mentioned in the requirements, it can be useful to have multiple
store environments. With some tweaks to the config, multiple
environments can be specified. The `config-example.yml` can be updated
to:

~~~
SHARED: &SHARED
  store: example.myshopify.com
  password: test
  theme_id: 'live'
  bucket_size: 40
  refill_rate: 2
  ignore_files:
    - "*.swp"
    - "*~"
    - "config/settings_data.json"

development:
  <<: *SHARED
  password: ADD_PASSWORD_HERE
  store: TEST_STORE_NAME.myshopify.com

production:
  <<: *SHARED
  password: ADD_PASSWORD_HERE
  store: LIVE_STORE_NAME.myshopify.com
~~~

The `SHARED` section of the config is the common values for both
environments. The specific environment config values extend `SHARED` and
overwrite the values as needed. This makes it easier to update and
manage the common settings.

Each environment requires its own Shopify store, and each store will
need a private app (which yields the password for the config).

In this config, `development` is the test store to be used while making
changes. Once the changes are complete, they will then be pushed up to
the `production` store.

The `theme` commands can now be used with the `env` flag, which
specifies the store to use. To watch for changes when developing, use
`theme watch --env development`. Once the changes are all set, the
`theme upload --env production` command will upload all of the theme to the
live store.

With multiple environments, you could setup continuous delivery (CD) to
automatically upload theme changes to production when a new Git tag is
pushed to GitHub or on other triggers.

## Scenarios To Watch Out For

There are a couple of scenarios to watch out with this workflow.

If someone makes direct changes to the theme in the Shopify
admin, they will not be part of the Git repo and could get wiped out
with any changes pushed up by Theme Kit. As long as no one is making
changes directly in the Shopify web theme editor, it should be fine. If
someone does and you know about it, those changes can be pulled with
`theme download` and then checked into the Git repository.

Occasionally I will start making changes to the theme before starting
`theme watch`. Those changes can be uploaded by saving the files again
while `theme watch` is running or by using the `theme upload` command
with the names of the files.

## Additional Reading

- [Thoughtbot's Shopify Theme
  Development](https://robots.thoughtbot.com/shopify-theme-development)
  post was a good reference when I exploring different approaches to
  theme development.
- The [Shopify docs on theme
  customization](https://help.shopify.com/themes/customization) are
  pretty useful for getting started.

## Wrap Up

This workflow has been working well for me so far. If you have any
questions, issues, or feedback on this workflow [reach out to me on
Twitter](https://twitter.com/brettchalupa).

-----

Looking for Shopify theme development help? [Reach out and let me know how I can help.](/hire/)
