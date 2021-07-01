---
layout: post
title: RSpec Mocking & Stubbing Explained
date: 2021-06-30 09:43 -0400
categories:
- Ruby
tags:
- TDD
- RSpec
- Mocking and Stubbing
- Screencasts
- Videos
series: RSpec Deep Dive
image: /img/rspec-mocking-and-stubbing-explained.jpg
author: Brett Chalupa
---

RSpec's stubbing and mocking library (known as rspec-mocks) took me years to
understand in practice and use effectively. But after using it regularly
throughout my career, it's among the first places I start in my tests when
defining the behavior of the code and then implementing it. In this screencast,
I cover creating a complex Order checkout method with tests using RSpec's
mocking and stubbing methods.

<iframe width="700" height="393" src="https://www.youtube.com/embed/ciVXLf6YnUE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

The common unit testing pattern with RSpec's mocking approach is generally to
expect methods on an object to be called, something along the lines of:

``` ruby
it "sends an email" do
  expect(Mailer).to receive(:send).with(:new_order, order.email)

  subject.checkout
end
```

The corresponding code that's driven out to make that pass is:

``` ruby
class Order
  attr_accessor :email

  def checkout
    Mailer.send(:new_order, @email)
  end
end
```

The expectation reads pretty naturally. This unit test may seem a bit... silly.
We're expecting code to be called and that's what happens. We're not testing
what's returned or any side-effects. Why even bother writing the test in the
first place if we could just write the code that does the same thing?

Well, I think there's value in this type of unit testing because generally we'd
start higher up with an end-to-end test or an integration test that gets us to
the point of needing `Order#checkout` to exist. And we use the spec to describe
what we want to happen and then use that to design the interfaces (or to call
out to already existing interfaces). While the example above is a bit trite, it
becomes useful when our method's needs become more complex.

Let's say that `Order#checkout` calls out to a payment gateway that processes
the payment that takes an `order`:

``` ruby
it "processes the payment" do
  expect(PaymentGateway).to receive(:process).with(card)

  subject.checkout
end
```

The code to make that test pass looks like:

``` ruby
def checkout
  PaymentGateway.process(self)
  Mailer.send(:new_order, @email)
end
```

This is still a bit simple, and yes, it's technically unit tested. We'd
expect that both `PaymentGateway#process` and `Mailer#send` are covered by
their own unit tests or we'd add them ourselves to have confidence they work in
isolation.

Where this style of mocking gets interesting and exceptionally useful is when
we need for branching logic based on return values in the code.

Let's look at this spec with two contexts to cover the paths:

``` ruby
context "when the payment gateway succeeds" do
  before do
    expect(PaymentGateway).to receive(:process).with(card) { :success }
  end

  it "sends a new order email" do
    expect(Mailer).to receive(:send).with(:new_order, order.email)

    subject.checkout
  end
end

context "when the payment gateway denies the charge" do
  before do
    expect(PaymentGateway).to receive(:process).with(card) { :failure }
  end

  it "does not send a new order email" do
    expect(Mailer).to_not receive(:send).with(:new_order, order.email)

    subject.checkout
  end
end
```

We now have tests for both paths in the code described... When the payment
gateway succeeds, send the email. When it fails, don't send the email. This
matches the needs of our application. Our above `#checkout` method would cause
these specs to fail.

The mocking pattern of using `expect(object).to receive(:some_method).with("some args") { "any return val" }`
is such a useful and common pattern. It makes it clear what's expected to
happen right away in the test. The block at the end is what's returned by the
method call. There are a lot of options for `#with` and other calls that can be
chained to this to have more specific expectations, but they're beyond the
scope of this post.

To make these tests path, we'd end up with:

``` ruby
def checkout
  if PaymentGateway.process(self) == :success
    Mailer.send(:new_order, @email)
  end
end
```

While our `#checkout` method is quite simple still, it's likely processing an
order has more needs than just that. When methods aren't as simple as passing
in a value and expecting something to be returned, this approach of mocking in
the tests makes it much easier to cover the behavior and have confidence in the
isolated unit-level behavior of the object and method under test.

## Additional Resources

- [Full source code from the episode](https://github.com/brettchalupa/screencasts/tree/master/rspec-mocking-explained)
- [RSpec docs on expecting messages](https://relishapp.com/rspec/rspec-mocks/v/3-10/docs/basics/expecting-messages)
- [RSpec docs on returning a value](https://relishapp.com/rspec/rspec-mocks/v/3-10/docs/configuring-responses/returning-a-value)
- [Mocks Aren't Stubs by Martin Fowler](https://martinfowler.com/articles/mocksArentStubs.html)
