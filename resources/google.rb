require "cgi"

class Google < Rubot::WebResource
  get :movies, "http://www.google.com/search" do |doc|
    movies = doc.css("#topstuff tr.std").map do |tr|
      next if tr.css("td a").text =~ /More movies/

      tds = tr.css("td")

      movie = []
      movie << tds[0].css("a").text
      movie << tds[1]
      movie << tds[2]
      movie << tds[3]
      
      movie.join(", ")
    end

    movies.compact.join(" --- ")
  end

  get :calc, "http://www.google.com/search" do |doc|
    doc.css(".r")[0].text
  end
  
  def self.search_url_for(query)
    "http://www.google.com/search?q=#{CGI.escape(query)}"
  end
  
  def self.lmgtfy_url_for(query)
    "http://www.lmgtfy.com/?q=#{CGI.escape(query)}"
  end
end
