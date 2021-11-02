---
title: Quickly Fix Bugs with Git Bisect
date: 2021-06-21 09:02:00 -04:00
categories:
- Git
tags:
- Screencasts
- Videos
layout: post
image: "/img/git-bisect.jpg"
author: Brett Chalupa
description: A walkthrough on how to use Git Bisect to identify regressions in codebases.
---

Support is reporting an urgent bug. Weirdly enough, no one else is around—folks are at lunch or on vacation. You respond to Support and let them know you're on it! The pressure's on, what do you do? You want to fix the bug quickly, but you don't even know where to begin. You didn't even introduce the darn thing!

Well, meet your new best friend—Git Bisect.

It is by far the quickest and most effective way to pinpoint the commit that introduced the bug, which will help you understand what's wrong and how to fix it.

<iframe width="700" height="393" src="https://www.youtube.com/embed/MqNy9f-K0G4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

How it works is pretty simple: you mark commits as "good" and "bad" to help Git more efficiently go through a series of commits to find the first "bad" commit, a.k.a. the commit that introduced the regression.

1. Start the bisecting process with `git bisect start`.
2. Then mark a commit that you know is bad with `git bisect bad`. This could be the latest commit on `master` branch or whatever your main branch.
3. Then checkout a past commit you know wasn't broken, test it out, and mark is with `git bisect good`. This could be a commit from a couple of days ago or the last tag you know it wasn't broken with. It may take a couple of checkouts to find a good commit, dependent on how long the bug has been present.

From there, Git checks out the next commit between the last bad one and the
most recent good one, where you can test the regression and see if it's
present. You then mark that commit as good or bad based on whether it works as
expected or not, e.g. `git bisect bad`. Rinse and repeat until you find the
commit that introduced the bug.

Once you reach the first bad commit, Git will output the message. It's a good
idea to save that commit SHA for easy reference. `git show THE_SHA_HERE` to see
what changed in the code. Sometimes it's obvious what the fix is, othertimes it
may require collaboration. You can chat with the author of the commit to
understand more context about the change and why it was made, or you can just
fix the issue. When you're ready to fix it, run `git bisect reset` to exit the
bisecting process. Fix the bug, release the changes, and you're good to go!

Git Bisect is also useful for non-urgent bugs too. It's the quickest way to
find the proverbial needle in the haystack when something isn't right that you
know used to be right!

[View the branch with the code in the tutorial on GitHub.](https://github.com/brettchalupa/brettcodes/tree/git-bisect-tutorial)

Curious to learn more about git bisect? [The docs are thorough and
fantastic.](https://git-scm.com/docs/git-bisect)
