.PHONY: post up bundle draft

up:
	bundle exec jekyll serve -w -D -l -o --port 4010 --livereload_port 8889

bundle:
	bundle install

draft:
	ruby make_post.rb --draft

post:
	ruby make_post.rb
