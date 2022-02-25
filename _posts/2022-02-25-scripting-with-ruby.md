---
layout: post
title: Scripting with Ruby
description: "A guide to the joy of using Ruby to write utility scripts for managing files."
image: "/img/scripting-with-ruby.jpg"
date: 2022-02-25 08:20 -0400
categories:
- The Fundamentals of Ruby
tags:
- Ruby
- Scripting
- Screencasts
- Videos
---

Ruby is a really fantastic language for writing general purpose scripts, especially when processing files. I find myself using it regularly for personal needs in addition to the daily needs of my job.

I recently wanted to organize thousands of MP3 files in a folder into subfolders based on the artist and album, so I wrote a little Ruby script to do so. It reminded me how fun it is to do and how Ruby can be quite a bit friendlier to work with than bash for writing little one-off scripts.

So that's what this post is: organizing a bunch of MP3s with a simple Ruby script and adding some error handling.

<iframe width="700" height="393" src="https://www.youtube.com/embed/4jrljM1Ha6o" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

The basic gist of the script is:

1. Create a back-up the files intended to process in case anything goes wrong (generally a good idea with these types of scripts)
2. Loop through each MP3 file in the folder
3. Read the file and the ID3 tags from the MP3
4. Ensure all the data needed is present
5. Clean up any characters that might cause issues
6. Create the directory based on the track's artist and album
7. Move the file into the folder

Here it is, `_organize.rb`, which could be dropped into the directory to organize or extended to accept a directory:

``` ruby
# Organize a directory of MP3s into subdirectories based on album, artist,
# track number, and track title.
#
# Creates a backup in `_backup` in case the script really makes a mess.
#
# Be sure it install id3tag first: gem install id3tag
#
# Run with: ruby _organize.rb

require "fileutils"
require "id3tag"

BACKUP_DIR = "_backup"
LIB_DIR = "Library"

mp3_files = Dir.glob("*.mp3")

puts "Cleaning up backup directory..."
FileUtils.rm_rf(BACKUP_DIR)

puts "Backing up mp3s..."
FileUtils.mkdir(BACKUP_DIR)
FileUtils.cp(mp3_files, BACKUP_DIR)

def scrub_invalid(str)
  str.gsub(/\//, '-')
end

puts "Organizing mp3s..."
mp3_files.each do |f|
  mp3 = File.open(f, "rb")
  tag = ID3Tag.read(mp3)

  required_attrs = [:track_nr, :artist, :album, :title]

  if required_attrs.any? { |a| tag.public_send(a).nil? }
    puts "Skipping #{f}, missing required metadata"
    next
  end

  track_num = tag.track_nr.split("/").first
  artist = scrub_invalid(tag.artist)
  album = scrub_invalid(tag.album)
  title = scrub_invalid(tag.title)

  dir = "#{LIB_DIR}/#{artist}/#{album}"
  FileUtils.mkdir_p(dir)

  FileUtils.mv(f, "#{dir}/#{track_num} - #{title}.#{f.split(".").last}")
end

puts "mp3s organized into #{LIB_DIR}"
```

It's certainly not perfect, but it's a fine starting place and worked well for my needs.

I also happened to have quite a few music files without metadata, so I first used [MusicBrainz Picard](https://picard.musicbrainz.org) to tag them, then I organized them myself.

Ruby is a lot of fun for writing this type of code, especially if you are familiar with its syntax and standard library.

## References

- [FileUtils](https://ruby-doc.org/stdlib-3.1.0/libdoc/fileutils/rdoc/FileUtils.html)
- [File](https://ruby-doc.org/core-3.1.0/File.html)
- [Dir](https://ruby-doc.org/core-3.1.0/Dir.html)
- [id3tag gem](https://rubygems.org/gems/id3tag) -- view MP3 metadata from a Ruby file

## Versions

- Ruby 3.1.0
- [id3tag 0.14.2](https://rubygems.org/gems/id3tag/versions/0.14.2)

## Source

[View the source on GitHub.](https://github.com/brettchalupa/screencasts/tree/master/scripting-with-ruby)
