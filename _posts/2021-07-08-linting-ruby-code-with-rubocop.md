---
layout: post
title: Linting Ruby Code with RuboCop
description: "A walkthrough on using RuboCop and general thoughts on code linting."
image: "/img/ruby-code-linting-with-rubocop-thumbnail.jpg"
date: 2021-07-08 08:20 -0400
categories:
- The Fundamentals of Ruby
tags:
- Ruby
- Scripting
- Screencasts
- Videos
---

RuboCop is a static code analyzer for Ruby code that can be used to lint code for consistency, catch errors, and support writing better code. In this screencast, I walkthrough how to run it, how to fix offenses, and refactoring code driven by RuboCop. I also share my thoughts on linting in general and what I've found to be the most valuable aspects of RuboCop after using it for over five years.

<iframe width="700" height="393" src="https://www.youtube.com/embed/sfOGjcMVQ9U" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## General Thoughts on Linting and Its Value

I need to be upfront here... After being a proponent of strict linting for years, I've cooled off on it recently and feel more more flexible and lenient about it. I think static code analyzers like RuboCop have their time and place and use, but I've been questioning the value of having consistently formatted code in a style guide that's _purely_ aesthetic preference.

When building software and having control over this little world of code that's been created, it's easy to want to have opinions on everything, even the most inconsequential of things. While there may be some valid reasoning in support for preferences, there's still a cost to having strict style enforcing. The team needs to conform to it, and it can be quite frustrating and bewildering for them.

_My code works and is refactored and optimized, what difference does this switch case statement style make?!_

When using RuboCop out of the box, it seems to follow [The Ruby Style Guide](https://github.com/rubocop/ruby-style-guide#the-ruby-style-guide), which has a lot of opinions about what's "bad" and what's "good." I'd like to posit that one's preferences aren't good or bad, but they're just preferences. And putting that kind of judgement on the code that people write for the sake of consistency doesn't _really_ gain a much value—at least not in my experience of using RuboCop across many projects and teams.

It's really easy to take code linting for styling too far, to have the test suite fail for an inconsequential style and just defer to the linting tool as the problem. But what does it really matter for something like this:

``` ruby
# bad
p = Proc.new { |n| puts n }

# good
p = proc { |n| puts n }
```

The code does the same thing, both are clear to me... Should the test suite fail because someone opens a PR with the "bad" example? Lately, I think not.

Having to have people conform to a style guide of preferences that are largely inconsequential seems like small potatoes compared to some of the bigger challenges and issues that come along with writing code—like the architecture, performance, and tests. Style, to me, is so personal, and I've been questioning the value in enforcing such strict rules that RuboCop comes with out of the box.

The nice thing about RuboCop and many code linters is that they're configurable. Checks/offenses can be turned on or off or have their settings changed. If you're on a team who is adding linting to your test suite's checks, letting go of some control in the minutiae when it comes to style may actually lead to people enjoying the process of using the linter more. Instead of seeing frustrating CI failures because of an inconsequential newline (or lackthereof), focus instead on how linters and tools can help you write more useful code by catching bugs early and supporting better structured code.

RuboCop definitely has checks that help me catch bugs and less-performant code, which is its biggest value to me. For example, it has a check for unreachable code. For example (trivial example, but it happens):

``` ruby
def unreachable_code
  foo = true
  if foo
    return
  end
  2 + 2
end
```

The `2 + 2` never gets called because it's unreachable, and RuboCop will catch that.

RuboCop can also help ensure classes and methods don't exceed a certain length, as well as methods not exceeding a certain level of complexity. When those fail, it can be frustrating, but it's usually a sign of needing to refactor a bit. Those sorts of suggestions can be useful, as can the checks that catch issues before they're shipped.

When adding linting tools, be mindful of what you're asking your team to do. Understand what aspects of the static code analyzer have the most value and prioritize those. It's really easy to take linting too far. In a manufactured environment where there's a lot of ability to assert control, it's okay to not have an opinion of every little thing and let people code in a style that prefer (assuming it doesn't have negative impacts on the things that matter most to the team).

## Resources

- [RuboCop website](https://rubocop.org/)
- [RuboCop docs](https://docs.rubocop.org/)
- [Code from the screencast](https://github.com/brettchalupa/converty/tree/6a3be5ceb4d7f87f2855393e4cfca36056743db3)
- [RuboCop config from the screencast](https://github.com/brettchalupa/converty/blob/6a3be5ceb4d7f87f2855393e4cfca36056743db3/.rubocop.yml)
