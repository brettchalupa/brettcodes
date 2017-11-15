---
title: Test Driven RSpec - Episode 04, Unit Testing Models
date: 2017-11-11 10:00:00 -08:00
categories:
- RSpec
tags:
- Screencasts,
- Videos,
- Ruby
layout: post
author: Brett Chalupa
description: A thorough look at unit testing Ruby on Rails models with RSpec.
comments: true
---

An in-depth look at unit testing Rails models with RSpec with TDD.

<iframe width="700" height="393" src="https://www.youtube-nocookie.com/embed/Vwb5LalpRwI?rel=0" frameborder="0" allowfullscreen></iframe>

This episode covers:

- Creating a `Console` model (0:45)
- Testing model validations (3:28)
- Testing model methods (12:17)
- Testing model scopes (15:12)
- Refactoring the `consoles` array of hashes into database queries (20:12)

[View the code.](https://github.com/monoso/test-driven-rspec/tree/master/episode-04)

[View the diff.](https://github.com/monoso/test-driven-rspec/commit/9e7a1eefde159b8089f47a322653178f45cb0e46)

[View the playlist.](https://www.youtube.com/playlist?list=PLr442xinba86s9cCWxoIH_xq5UE9Wwo4Z)

Key code from the episode:

``` ruby
# db/migrate/20171111171300_create_consoles.rb
class CreateConsoles < ActiveRecord::Migration[5.1]
  def change
    create_table :consoles do |t|
      t.string :name, null: false
      t.string :manufacturer, null: false

      t.timestamps
    end
  end
end
```

``` ruby
# app/models/console.rb
class Console < ActiveRecord::Base
  validates :name, presence: true
  validates :manufacturer, presence: true

  scope :nintendo, -> { where(manufacturer: 'Nintendo') }

  def formatted_name
    "#{manufacturer} #{name}"
  end
end
```

``` ruby
# spec/models/console_spec.rb
require 'rails_helper'

RSpec.describe Console do
  subject { described_class.new(manufacturer: 'Nintendo', name: 'Wii') }

  describe 'validations' do
    describe 'name' do
      it 'must be present' do
        expect(subject).to be_valid
        subject.name = nil
        expect(subject).to_not be_valid
      end
    end

    describe 'manufacturer' do
      it 'must be present' do
        expect(subject).to be_valid
        subject.manufacturer = nil
        expect(subject).to_not be_valid
      end
    end
  end

  describe '#formatted_name' do
    it 'returns the manufacturer and name in a string' do
      expect(subject.formatted_name).to eql('Nintendo Wii')
    end
  end

  describe '.nintendo' do
    it 'returns an ActiveRecord::Relation of consoles manufacturered by Nintendo' do
      wii = described_class.create(manufacturer: 'Nintendo', name: 'Wii')
      switch = described_class.create(manufacturer: 'Nintendo', name: 'Switch')
      described_class.create(manufacturer: 'Sony', name: 'PS4')

      expect(described_class.nintendo).to contain_exactly(
        wii,
        switch
      )
    end
  end
end
```

``` ruby
# app/controllers/consoles_controller.rb
class ConsolesController < ApplicationController
  def index
    if params[:manufacturer].present?
      consoles = Console.where(manufacturer: params[:manufacturer])
    else
      consoles = Console.all
    end

    render(json: { 'consoles' => consoles.map(&:formatted_name) })
  end
end
```

``` ruby
# spec/requests/consoles_spec.rb
require 'rails_helper'

RSpec.describe 'Consoles requests' do
  before do
    Console.create(name: 'NES', manufacturer: 'Nintendo')
    Console.create(name: 'SNES', manufacturer: 'Nintendo')
    Console.create(name: 'Wii', manufacturer: 'Nintendo')
    Console.create(name: 'Genesis', manufacturer: 'Sega')
    Console.create(name: 'Xbox', manufacturer: 'Microsoft')
    Console.create(name: 'Switch', manufacturer: 'Nintendo')
    Console.create(name: 'PS1', manufacturer: 'Sony')
    Console.create(name: 'PS2', manufacturer: 'Sony')
  end

  describe 'GET /consoles' do
    it 'returns an array of the consoles' do
      get('/consoles')
      expect(response_json['consoles']).to contain_exactly(
        'Nintendo NES',
        'Nintendo SNES',
        'Nintendo Wii',
        'Sega Genesis',
        'Microsoft Xbox',
        'Nintendo Switch',
        'Sony PS1',
        'Sony PS2'
      )
    end

    it 'supports specifying consoles for a specific manufacturer' do
      get('/consoles', params: { manufacturer: 'Nintendo' })
      expect(response_json['consoles']).to contain_exactly(
        'Nintendo NES',
        'Nintendo SNES',
        'Nintendo Wii',
        'Nintendo Switch'
      )
    end
  end
end
```

Software used:

- Ruby 2.4.2
- RSpec 3.6.1
- Rails 5.1.4
- Mac OS
- iTerm 2
- Vim
- Tmux
