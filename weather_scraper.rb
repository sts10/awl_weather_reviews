require 'csv'
require 'pry'
require 'nokogiri'
require 'open_uri_redirections'

class Post
  attr_reader :url, :headline, :image_url, :text, :stars
  def initialize(row)
    @url = row[0]
    @image_url = row[1]
    begin
      puts "url attempting to open:#{url}"
      @doc = Nokogiri::HTML(open(@url, :allow_redirections => :safe))
    rescue
      puts "chillin for a hot second"
      sleep 120
      @doc = Nokogiri::HTML(open(@url, :allow_redirections => :safe))
    end
    self.scrape
  end

  def scrape
    @headline = @doc.css("h3.graf--leading").text
    @text = @doc.css("p.graf--p:first").text
    if @text&.split(" ")[0].include?("★")
      @stars = @text.split(" ")[0].size 
    else
      @stars = 0
    end
  end
end

all_scraped_posts = []
posts_scraped = 0
CSV.foreach("csv/weather_reviews.csv") do |row|
  this_post = Post.new(row)
  all_scraped_posts << this_post

  posts_scraped = posts_scraped + 1
  puts "have scraped #{posts_scraped} posts"
end

CSV.open("csv/weather_posts_scraped.csv", "w") do |csv|
  all_scraped_posts.each do |post|
    csv << [post.url, post.headline, post.image_url, post.text, post.stars]
  end
end


