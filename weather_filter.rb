require 'csv'

CSV.foreach("csv/all_posts.csv") do |row|
  if row[1].include?("weather-review") || row[2].include?("weather review")
    weather_rows << row
  end
end
  
CSV.open("csv/weather_reviews.csv", "w") do |csv|
  weather_rows.each do |row|
    csv << row
    puts row
  end
end


