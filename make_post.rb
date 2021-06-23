print "Post name: "
command = ARGV.first == "--draft" ?  "draft" : "post"
ARGV.clear
name = gets.chomp.strip
puts `bundle exec jekyll #{command} #{name}`
