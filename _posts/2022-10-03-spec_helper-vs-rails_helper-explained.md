---
layout: post
title: RSpec's spec_helper vs rails_helper Explained
description: "A look at the difference between them and when to use each."
image: "/img/spec_helper-vs-rails_helper.webp"
date: 2022-10-03 11:00 -0400
categories:
- RSpec
tags:
- Screencasts
- Videos
---

When you install RSpec in your Rails application, two of the files it generates are `spec/spec_helper.rb` and `spec/rails_helper.rb`. The generated source contains a lot of helpful comments, but it might not be immediately clear why there are two helpers instead of one.

<iframe width="700" height="393" src="https://www.youtube-nocookie.com/embed/UkctRoFvSuc" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Intro to the helpers

When you write specs in your Rails app, at the top of each file you require a helper that loads RSpec and other dependencies:

``` ruby
require "spec_helper"
require "word_count"

RSpec.describe WordCount do
  # your specs here
end
```

Or with `rails_helper`:

``` ruby
require "rails_helper"

RSpec.describe User do
  # your specs here for the User model
end
```

Which file you choose to require has implications when it comes to running unit tests for a given file or directory. Let's dig into what those implications are and the differences between them.

## spec_helper’s purpose

`spec_helper` is intended to be the most lightweight, fast RSpec config in your app. It's great for testing plain old Ruby objects (POROs) that don't require Rails. Even if those POROs require a gem or other classes, if they don't need Rails, you can use `spec_helper`.

The `spec_helper` is what you'd use if you are testing a Ruby gem with RSpec or anything non-Rails. It configures RSpec and that's just about it.

## rails_helper’s purpose

`rails_helper` requires `spec_helper` at the very top of the file, so it pulls in all of the config from that. So `spec_helper` is our base and `rails_helper` stacks on top of it.

You might be thinking, _why not just have one helper and keep it easy?_

I've certainly worked in codebases that do that, but that was before people understood that keeping them separate is important, especially when it comes to fast TDD cycles.

Running individual tests that require `spec_helper` is _much_ faster than requiring `rails_helper` because it's not loading all of the Rails app and gems. It's just loading RSpec, the spec_helper, and the files required for the test.

The `rails_helper` exists to be used with specs that test functionality that can't exist without Rails—controllers, routes, models, views. When testing a model's validations, you'll want to make sure those are happening in the context of Rails and working correctly, so you need to require Rails.

The `rails_helper` is also useful for configuring gems and support files needed by those tests, like setting up FactoryBot. It's also where you might want to reset and clean up the database after every test run (an timely operation in the context of fast tests).

## The speed differences

With a fresh Rails 7 codebase ([source](https://github.com/brettchalupa/screencasts/tree/main/spec-helper-vs-rails-helper)), here's the difference in speed for testing one plain Ruby class's method that lives in `lib`:

- `spec_helper`: Finished in 0.00182 seconds (files took 0.04228 seconds to load)
- `rails_helper` (cold run): Finished in 0.01671 seconds (files took 1.07 seconds to load)
- `rails_helper` (warm run): Finished in 0.01058 seconds (files took 0.45144 seconds to load)

There are two values to be aware. The time it takes to run the specs (the first number) and the time it takes to load the files from disk. They are separate values and their aggregate is the total time it takes to run a given spec (or specs).

The spec_helper loads the files for testing 25x faster on cold runs! Even on a warm run with the files already loaded, spec_helper is still 10x faster as loading the files!

On top of that, running the actual code in the specs is 10x faster than both.

That's a huge difference when it comes to the time it takes and you'll notice it as you're going through the Red -> Green -> Refactor TDD cycle.

## Why is this?

This happens because the `rails_helper` is loading hundreds, potentially thousands of Ruby files and configuring the Rails app. Rails does a lot! Look at your `Gemfile.lock` and see the depedency tree. Even if you have only ~15 gems in in your `Gemfile`, it's likely there are far more than that because each gem has its own dependencies.

There's a cost to pulling in dependencies and working with an application framework as large as Rails—it slows things down.

## What does this mean?

This means that if you want to have faster tests when you're actively writing your code, you'll want to require `spec_helper`.

## But what does this mean, really? I'm building a Rails app, I need `rails_helper`.

I get it. You're writing view, controller, and model code that all needs Rails to test them properly. That's true. And those tests are valuable. But there are still things you can do and should be aware of.

### Use plain old Ruby objects (POROs)

There comes a point when writing code you actually aren't doing anything related to Rails. Sure, maybe the objects being acted upon are models, but you could use POROs and then in your tests pass in `instance_double` and require `spec_helper`. When you build complex applications beyond CRUD, you'll begin to write more Ruby code that's not dependent on Rails.

You'll also be writing more unit tests, which, in general, won't need Rails. So you want to really leverage `spec_helper` when writing unit tests for POROs.

Your POROs can live in `lib` or in `app`, wherever you want to put them. That's up to you ultimately.

### Slowest common denominator

It is important to note that the speed of your tests will ultimately come down to the slowest required helper. If you have three spec files that get run and one of them requires `rails_helper`, that'll cause all of them to run slower because the file loading time is as slow as the slowest helper.

Since you're most likely running all of your tests on CI or occassionally on your machine, that's not a big deal. But it's something to be aware of. What you require won't impact the speed of your entire test suite running. For that, you'd need parallelization and a deeper dive into fixing your slowest specs.

What we're optimizing for is the tests you run while you're actively writing your code. Those individual file test runs _need_ to be fast. Any friction and slowdown breaks focus.

### Create other helpers

Just like how rspec-rails creates two helpers from the get-go, you can do the same! Do you use Capybara for acceptance tests? Create `spec/acceptance_helper.rb` that requires `rails_helper` (thus also requiring `spec_helper`) that configures Capybara and then in those specs:

``` ruby
require "acceptance_helper"
```

There's no reason to slow down all of your Rails unit tests with the loading and configuring of even more code.

You can create whatever helpers you want. If you've got a directory of POROs in `lib` that all require a common set up, create a helper for them that requires `spec_helper`.

## In summary

- Optimize for fast single file test runs, which is where speed matters most with TDD
- Keep `spec_helper` as minimal as possible, basically only configure the core of RSpec in it
- Be mindful of what you `require`
- Use POROs when possible for their clarity, their single responsibility, and faster unit tests
- Create separate helpers for different needs in your app, don't make single file test runs slower just because you need something loaded and configured in other specs

Managing your spec helpers and being intentional about them and understanding the difference is a major part in having fast, maintainable tests with Rails and RSpec.

