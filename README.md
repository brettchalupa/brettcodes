# Monoso Website

The website of Monoso, built with [Jekyll](http://jekyllrb.com).

## Developing

1. Clone the repository
2. Install the dependencies - `bundle install`
3. Start up the Jekyll server and show drafts - `jekyll serve -w -i -D`
4. Make changes

## Hosting & Deploying

The site is hosted and served via GitHub Pages. New changes get deployed
by pushing to `master` branch.

## Authoring Content

[jekyll-compose](https://github.com/jekyll/jekyll-compose) can be used
to create content more easily, with commands like:

- `bundle exec jekyll post "My New Post"`
- `bundle exec jekyll draft "My New Draft"`

## Plugins

The site makes use of plugins that GitHub Pages supports with Jekyll.
See the `gems:` section in `_config.yml` for the full list.

- [jekyll-seo-tag](https://github.com/jekyll/jekyll-seo-tag) - easy
  SEO-goodness in the site
- jemoji - using emojis in the content :sun_with_face:
- jekyll-sitemap - generating a sitemap
- jekyll-feed - generating an Atom feed

## License

Copyright (c) Monoso 
