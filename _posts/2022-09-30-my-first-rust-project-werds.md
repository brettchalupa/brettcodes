---
layout: post
title: My First Rust Project
description: "Building a simple CLI to count the number of words in the specified file(s)"
date: 2022-09-30 11:30 -0400
categories:
- Projects
tags:
- Rust
- Open Source
---

I've been working on learning Rust lately, just for fun. I was wondering how many words I've written so far for _[Projectbook](https://projectbook.code.brettchalupa.com)_, and I realized that's a great opportunity to build a program like `wc` in Rust! It's a simple enough idea and a program I'd use from time to time.

So I created a new Rust project and cobbled together `werds`! It's a simple CLI that can take text from stdin or one or more files and output the total number of words.

```
$ werds *.md
LICENSE.md: 118
README.md: 95
total: 213
```

I've got some more functionality I want to add to it, and it's certainly beginner-quality Rust code, but I'm having fun and learning a ton.

Here's the source if you're interested: [https://github.com/brettchalupa/werds](https://github.com/brettchalupa/werds), along with instructions on how to install it. I haven't built any distributable binaries yet.

The [Command Line Applications in Rust](https://rust-cli.github.io/book/index.html) book was immensely helpful in getting started. It outlines the basics of building a program with Rust that can run from the terminal.

While I'm still working on `werds` and don't have much confidence in the code I've written so far, I do have some early thoughts on learning and using Rust that I'd love to share.

## Being a beginner is difficult

I've been writing code for over 15 years, professionally for over ten. And to be a beginner again at a language that's quite different from those that I know is challenging. It makes me feel a little like an imposter, like maybe I don't even know how to code. But that's not true! It's the case when learning anything new, and my past experiences do help me.

But it's difficult when working with a new language (or framework or library) to not know how to do the things that come easier in languages you're experienced with.

The frustration and then joy that comes from doing something wrong and then figuring out is part of what makes coding so fun for me. And that's been a refreshing reminder.

## So many resources

When searching online for most questions I had, whether they were compiler errors or concepts, I'd often find detailed answers, documentation, and guides. This makes a language much easier to learn. While reading books and watching screencasts are helpful, it's often not until I'm actually writing code and getting stuck that I truly learn something.

Even though Rust is relatively new, it's been around long enough with a vocal commmunity that there's tons of information available online.

Some resources I'd like to highlight:

- [The New Rustacean podcast](https://newrustacean.com) — bite-sized episodes about learning Rust
- [Rustlings](https://github.com/rust-lang/rustlings) — interactive exercises for learning Rust
- [The Rust Book](https://doc.rust-lang.org/book/)
- [Rust by Example](https://doc.rust-lang.org/rust-by-example/)

## Great community

I had a question about packaging up a Rust project that I couldn't find an answer for. It was whether or not to exclude test files and fixture files from the crate (the name for a Rust package). Since I couldn't find an answer, [I asked on the Rust forum](https://users.rust-lang.org/t/should-test-files-and-fixtures-be-excluded-from-cargo-projects-when-packaging/81949?u=brettchalupa) and got a prompt, clear answer. Amazing!

It can be scary to ask a question to the void, but to get a helpful response really means a lot.

## Rust's approach to ownership is clear and powerful

A unique feature to rust is how it approaches the lifetime of variables and who owns it. [The Rust book](https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html) does a great job explaining it. And coming from Ruby and JavaScript, where memory and the lifetime of a variable aren't primary concerns, it took me a little bit to understand and grasp. I was brought back to my C++ days in college! I think/hope this will get easier in time, but it's extremely helpful to understand who owns what when writing the code. I think it'll lead to writing better programs.

## Compilers can be helpful

I've found Rust's compiler errors to be detailed and helpful. And integrating the [rust-analyzer](https://github.com/fannheyward/coc-rust-analyzer) language server with Neovim means I get instant feedback on the code I'm writing. When working in Ruby, because it's a dynamically typed and scripted language, it means I have to rely on unit tests and actually running the application to verify it's working. But to have the compiler watching my back and getting that feedback quicker means I'm learning faster and catching mistakes sooner.

I've found this to also be true with TypeScript, which I've been working with more and more over the last few years.

The compiler with static typing really gives me a higher degree of confidence with the code I'm writing, and that's majorly important. Even more so when writing code that's shared with a team of any size. The time it takes to understand the type system and explicitly map out the data model pays off when you're writing code that interacts with that data.

## What's to come

I'd like to make `werds` better and keep learning in that low-stakes project. I'll certainly take on more learning projects in Rust. I'm not sure what my end goal is other than to learn the language and make programs with it. I'm particularly interested in using it for game dev and API development, so I'm looking forward to learning about using Rust in those realms soon.
