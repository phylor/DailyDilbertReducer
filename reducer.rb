require 'open-uri'
require 'rss'
require 'nokogiri'

feed_file = File.read('feed_file_location.conf')

class Comic
  attr_accessor :title, :url, :date

  @title
  @url
  @date
end

class ComicsFeed
  @title
  @comics

  def initialize
    @comics = Array.new
  end

  def update_data
    feed_content = open('http://feeds.feedburner.com/DilbertDailyStrip')

    feed = RSS::Parser.parse(feed_content)
    @title = feed.channel.title

    feed.items.each do |item|
      comic = Comic.new
      comic.title = item.title
      comic.date = item.date

      website = Nokogiri::HTML(open(item.link))

      website.xpath('//img[contains(@title, "The Dilbert Strip for")]/@src').each do |imgsrc|
        comic.url = imgsrc
      end

      @comics << comic
    end
  end

  def create_feed
    rss = RSS::Maker.make("atom") do |maker|
      maker.channel.author = ''
      maker.channel.updated = Time.now.to_s
      maker.channel.about = ''
      maker.channel.title = @title

      @comics.each do |comic|
        maker.items.new_item do |item|
          item.link = ''
          item.title = comic.title
          item.updated = comic.date
          item.summary = "<img src='http://dilbert.com/#{comic.url}' />"
        end
      end
    end

    return rss
  end
end

#todo:

feed = ComicsFeed.new

def get_days_not_updated(feed_file)
  if not File.exist?(feed_file)
    100
  else
    DateTime.now - File.mtime(feed_file)
  end
end

days_not_updated = get_days_not_updated(feed_file)
if days_not_updated >= 1
  feed.update_data
  File.write(feed_file, feed.create_feed)
end