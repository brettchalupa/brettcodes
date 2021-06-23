.PHONY: post up bundle draft

up:
	bundle exec jekyll serve -w -D

bundle:
	bundle install

draft:
	ruby make_post.rb --draft

post:
	ruby make_post.rb
