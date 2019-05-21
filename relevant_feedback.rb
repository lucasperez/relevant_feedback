require 'google_custom_search_api'
require 'terminal-table'

GOOGLE_API_KEY = "AIzaSyBHYSadPQFIbnbgpH0r3NJpDWdARepCzS4"
GOOGLE_SEARCH_CX = "014062119054397272337:4u6z3mq1eoa"

class RelevantFeedback

  def initialize
    @responses = []
    @search_numbers = 0
  end

  def search(query_string, elements_number)
    search_depth(query_string, elements_number)
    return @responses
  end
  
  private

  def search_depth(query_string, elements_number)
    results = GoogleCustomSearchApi.search(query_string, language: "Portuguese")
    if @search_numbers < elements_number
      @search_numbers = @search_numbers + 1
      results["items"].first(elements_number).each do |item|
        @responses << item
      end    
      @responses.each do |response|
        search_depth(response["title"], elements_number)
      end
    end
  end
end