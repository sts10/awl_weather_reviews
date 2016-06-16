require 'csv'
require 'pry'

weather_rows = []
CSV.foreach("csv/all_posts.csv") do |row|
  if row[1]&.include?("weather-review") || row[2]&.include?("weather review")
    weather_rows << row
    puts "found a weather review"
  end
end
  
CSV.open("csv/weather_reviews.csv", "w") do |csv|
  weather_rows.each do |row|
    csv << row
    puts row
  end
end


