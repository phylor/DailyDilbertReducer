# Daily Dilbert Reducer

The daily Dilbert feed on <http://dilbert.com> does not include the comic itself in the feed. Instead it links to the website.

The Daily Dilbert Reducer is a small script which transforms the feed so that it includes the comics directly.

## What is needed to run it?
* Ruby
* Any web server
* Scheduler (e.g. cron)

## How does the Reducer work?
It fetches the official Dilbert feed, transforms it and writes the new feed to a local file. That file can be served by a web server, so that it can be added to an RSS feeder.

## How is it installed?
1. Clone the repository to a location on your server
2. Run `bundle` to install all gems
3. Edit the file `feed_file_location.conf` to include the file path to the new feed your web server is going to serve. Example: `/var/www/example.com/dilbert.rss`
4. Configure your scheduler to run the script regularly, e.g. daily. If you use cron, add a script like the following to `/etc/cron.daily/`. You have to adapt the path to point to the clone location of this repository.
5. Add the URL to your feed to your RSS reader, e.g. `http://example.com/dilbert.rss`

### Sample cron script

	#!/bin/bash
    cd /opt/local/DailyDilbertReducer
    ruby reducer.rb

