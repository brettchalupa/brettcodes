---
title: RSpec Test Doubles Explained
date: 2021-06-28 08:37:00 -04:00
categories:
- Ruby
tags:
- TDD
- RSpec
- Mocking and Stubbing
- Screencasts
- Videos
layout: post
series: RSpec Deep Dive
image: "/img/rspec-test-doubles-explained-thumbnail.jpg"
author: Brett Chalupa
---

<bc-youtube-video token="S9KJOv4UJMY"></bc-youtube-video>

When writing unit tests, it's encouraged to write you tests in isolation from other objects so that your tests don't rely upon the implemention of those other objects. As long as what the dependencies implement and return stays the same, their implementation can change with the tests for your object changing. The benefit is that this allows for simpler and faster tests.

RSpec has a great interface test doubles, as well as a configuration option for verifying the classes and methods of the double actually exist. Pretty cool! Let's dive into how it could be useful.

Let's say we have a Ruby class called `Router`. It looks like this:

``` ruby
class Router
  def initialize(domain:, protocol: "https")
    @domain = domain
    @protocol = protocol
  end

  def url_for(object)
    "#{@protocol}://#{object.subdomain}.#{@domain}/#{object.slug}"
  end

  private

  attr_reader :domain, :protocol
end
```

The `#url_for` method returns a full URL as a string based on the passed in object. Let's say we have a blogging app that allows people to create a blog and add posts so that blog. Let's call this app Bloggo. We could imagine in our code, let's say in an ERB template in our Bloggo back-end to view a live post, calling some code like:

``` erb
<a href="<%= App.router.url_for(@post) %>">View post</a>
```

## Writing Tests with Doubles

`double` in RSpec creates an object. The first param is a string to identify it. Usually I use the class name it's a double of, but more on that soon. Then you pass in keys and values for the methods you want to stub out. Given `post = double("Post", subdomain: "brettcodes")`, calling `post.subdomain` would return the string `"brettcodes"`.

That's basically it. Now you have an object you can pass around that behaves like the object you want it to but with a much simpler set up and no concern for its implementation.

In our unit tests for `Router#url_for`, we could pass in a real `Post` instance. But `Post` is complex to create and needs all sorts of other data set up. All we care about is the methods needed to satisfy `#url_for`.

This spec below covers `Router#url_for` with a passed in Post. You'd want to have an integration test or e2e test that exercises this full stack for confidence, but this covers the full unit test for a Post.

``` ruby
require 'spec_helper'

RSpec.describe Router do
  subject { described_class.new(domain: "bloggo.com") }

  describe "#url_for" do
    context "with a post" do
      it "returns the full URL with protocol, subdomain, and path" do
        post = double("Post", subdomain: "brettcodes", slug: "using-rspec-test-doubles")

        expect(subject.url_for(post)).to eql(
          "https://brettcodes.bloggo.com/using-rspec-test-doubles"
        )
      end
    end
  end
end
```

## Verifying Doubles

But because `double` is so loosey-goosey, you can define any attribute you want. `double("Post", favorite_singer: "Cher")` is possible, but `Post` doesn't implement `#favorite_singer`. This can lead to the creation of an entirely fake world that your tests are built around. This is dangerous. Your e2e and integration tests would catch this, but it's better to be grounded in reality sooner rather than later.

That's why RSpec has `instance_double`, a method that _verifies_ the mocked class and stubbed methods actually exist. Awesome!

So if you instead did `post = instance_double("Post", favorite_singer: "Cher")`, RSpec will fail right away with this error:

```
Failure/Error: post = instance_double("Post", favorite_singer: "Cher")
  the Post class does not implement the instance method: favorite_singer
```

This is so helpful because you have more confidence that what you're mocking is pretty close to reality. You could then fix your double or implement `favorite_singer` in the `Post` class with its own unit tests.

The first param must be the class or constant that RSpec will verify against. It can be a string, that way you don't have to rely upon the constant. Make sure your code is autoloaded before your config in your spec_helper though, otherwise it won't verify.

So we'd change our spec above to be:

``` ruby
it "returns the full URL with protocol, subdomain, and path" do
  post = instance_double("Post", subdomain: "brettcodes", slug: "using-rspec-test-doubles")

  expect(subject.url_for(post)).to eql(
    "https://brettcodes.bloggo.com/using-rspec-test-doubles"
  )
end
```

And we're good to go!

Modern RSpec config (at least 3.10.0) enables verified doubles by default. But if you don't have it enabled, check your spec_helper for:

``` ruby
config.mock_with :rspec do |mocks|
  mocks.verify_partial_doubles = true
end
```

## Raising an Error if Incompatible

In order for an object to be routable, it needs to implement `subdomain` and `slug`, otherwise the generated URL won't work. That's no good. What should happen if we pass in an object that isn't routable? Well, I think it'd be nice to raise an error. Let's expand on that by using a non-verified double. It's just _some_ object that doesn't implement those methods.

Let's add this error class to `Router`:

``` ruby
class Router
  class NotRoutableError < StandardError; end
end
```

In our spec, we'll add something like:

``` ruby
context "with an object that does not implement subdomain and slug" do
  it "returns a NotRoutableError" do
    unroutable = double("unroutable")

    expect { subject.url_for(unroutable) }.to raise_error(described_class::NotRoutableError)
  end
end
```

`unroutable` doesn't need to be verified because it's not a real thing. It's just some object. It could represent any class that doesn't implement those methods. This is why we're unit testing. To cover these cases when our code doesn't adhere to the happy path. This is the sad path.

In `Router#url_for`, we can verify the passed in object is routable, for example:

``` ruby
def url_for(object)
  raise NotRoutableError.new unless object.respond_to?(:subdomain) && object.respond_to?(:slug)

  "#{@protocol}://#{object.subdomain}.#{@domain}/#{object.slug}"
end
```

There we go!

## In Summary

- Test doubles are great for instantiating objects in unit tests to not rely upon their implementations or side-effects
- For most cases, you want to use `instance_double` over `double` to get that sweet, sweet verification of the mocked class and stubbed methods
- But sometimes `double` on its own is nice if you don't care about what's being passed in
- Be sure to have e2e or integration tests to back-up the reality you've manufactured in your unit tests!

## Additional Resources & Thoughts

### FactoryBot

In the code and screencast above, it's just plain Ruby with no dependencies aside from RSpec. But if you're using something like `FactoryBot`, you can take advantage of your factories with stubbing still. You can use `build_stubbed(:post)` to create a double-esque object based on your `:post` factory. Kind of neat. There's a time and place for that, that I'd like to cover soon.

### Links!

- [Source from the post and episode](https://github.com/brettchalupa/screencasts/tree/master/rspec-test-doubles-explained)
- [RSpec docs on doubles](https://relishapp.com/rspec/rspec-mocks/v/3-10/docs/basics/test-doubles)
- [RSpec docs on verified instance_double](https://relishapp.com/rspec/rspec-mocks/docs/verifying-doubles/using-an-instance-double)
