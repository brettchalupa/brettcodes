---
title: Test Driven RSpec - Episode 05, Capybara Basics
date: 2017-11-13 10:30:00 -08:00
categories:
- RSpec
tags:
- Screencasts,
- Videos,
- Ruby,
- Capybara
layout: post
author: Brett Chalupa
description: An introduction to using Capybara with RSpec to test web pages in a Rails
  app.
comments: true
---

An introduction to using Capybara with RSpec to test web pages in a
Rails app.

<iframe width="700" height="393" src="https://www.youtube-nocookie.com/embed/nsj7nBslgnk?rel=0" frameborder="0" allowfullscreen></iframe>

This episode covers:

- Configuring Capybara with RSpec
- Visiting pages
- Expecting content to be present
- Clicking links
- Testing the current URL

If you're interested in learning more about Capybara, [the project's README](https://github.com/teamcapybara/capybara) is great. I'll also be covering it more in future episodes.

[View the code.](https://github.com/monoso/test-driven-rspec/tree/master/episode-05)

[View the diff.](https://github.com/monoso/test-driven-rspec/commit/6618d193b708536216b22d920b547b01d6468b60)

[View the playlist.](https://www.youtube.com/playlist?list=PLr442xinba86s9cCWxoIH_xq5UE9Wwo4Z)

Key code from the episode:

`spec/rails_helper.rb`:

``` ruby
# Add this line below require 'rspec/rails'
require 'capybara/rspec'
```

`spec/features/home_spec.rb`:

``` ruby
require 'rails_helper'

RSpec.describe 'Home features' do
  it 'displays the name of the app and links to the About page' do
    visit('/home')
    expect(page).to have_content('Game Tracker')
    click_link('About')
    expect(current_path).to eql('/about')
    expect(page).to have_content('About')
  end
end
```

`config/routes.rb`:

``` ruby
Rails.application.routes.draw do
  get('home' => 'home#index')
  get('about' => 'about#index')
  get('status' => 'status#index')
  get('consoles' => 'consoles#index')
end
```

`app/controllers/home_controller.rb`:

``` ruby
class HomeController < ApplicationController
  def index
  end
end
```

`app/views/home/index.html.erb`:

``` erb
<h1>Game Tracker</h1>

<%= link_to('About', about_path) %>
```

`app/controllers/about_controller.rb`:

``` ruby
class AboutController < ApplicationController
  def index
  end
end
```

`app/views/about/index.html.erb`:

``` erb
<h1>About</h1>
```

Software used:

- Ruby 2.4.2
- RSpec 3.6.1
- Capybara 2.15.4
- Rails 5.1.4
- Mac OS
- iTerm 2
- Vim
- Tmux
