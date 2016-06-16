require 'csv'
require 'pry'
require 'nokogiri'
require 'open_uri_redirections'

class Post
  attr_reader :url, :image_url, :text, :stars
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
    # @posts = []
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

CSV.foreach("csv/weather_reviews.csv") do |row|
  this_post = Post.new(row)
end

# CSV.open("csv/weather_posts_scraped.csv", "w") do |csv|
#   weather_rows.each do |row|
#     csv << [row[0], row[1]]
#     puts row
#   end
# end


