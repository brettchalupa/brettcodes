---
title: Test Driven RSpec - Episode 03, Configuring RSpec
date: 2017-11-09 13:00:00 -05:00
categories:
- RSpec
tags:
- Screencasts
- Videos
- Ruby
layout: post
author: Brett Chalupa
description: A deep-dive into configuring RSpec for Rails apps.
comments: true
---

The third episode in the series of screencasts covering Test Driven
Development with RSpec. This episode goes over what the three main
configure files for RSpec do.

<iframe width="700" height="393" src="https://www.youtube-nocookie.com/embed/mHPKEdgLirA?rel=0" frameborder="0" allowfullscreen></iframe>

This episode goes into detail on:

- The `.rspec` file
- `spec/spec_helper.rb`, its various options, and when to require it
- RSpec `spec/examples.txt` and using `--only-failures`
- RSpec output formats
- RSpec slow test profiling options
- RSpec test seed and its importance
- `spec/rails_helper.rb`, its various options, and when to require it
- Requiring and including `spec/support/` code in specs

Be sure to check out the [rspec-rails README](https://github.com/rspec/rspec-rails) for more info.

[View the code.](https://github.com/brettchalupa/test-driven-rspec/tree/master/episode-03)

[View the playlist.](https://www.youtube.com/playlist?list=PLr442xinba86s9cCWxoIH_xq5UE9Wwo4Z)

Software used:

- Ruby 2.4.2
- RSpec 3.6.1
- Rails 5.1.4
- Mac OS
- iTerm 2
- Vim
- Tmux
