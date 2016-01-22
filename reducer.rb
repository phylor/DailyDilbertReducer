require 'open-uri'
require 'rss'
require 'nokogiri'

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

    feed = RSS::Parser.parse(feed_content, false, false)
    @title = feed.title.content

    feed.items.each do |item|
      comic = Comic.new
      comic.title = item.title
      comic.date = item.updated

      website = Nokogiri::HTML(open(item.link.href))

      website.xpath('//img[contains(@alt, "- Dilbert by ")]/@src').each do |imgsrc|
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
          item.title = comic.title.content
          item.updated = comic.date.to_s
          item.summary = "<img src='#{comic.url}' />"
        end
      end
    end

    return rss
  end
end

def get_days_not_updated(feed_file)
  if feed_file.nil? || feed_file.empty? || (not File.exist?(feed_file))
    100
  else
    DateTime.now - File.mtime(feed_file).to_date
  end
end


feed_file = File.read('feed_file_location.conf').strip
feed = ComicsFeed.new

days_not_updated = get_days_not_updated(feed_file)
if days_not_updated >= 1
  feed.update_data
  File.write(feed_file, feed.create_feed)
end
