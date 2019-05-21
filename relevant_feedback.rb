require 'google_custom_search_api'
require 'terminal-table'
require 'active_support/all'

@config = YAML.load(File.open("./config.yml"))
GOOGLE_API_KEY = @config["google"]["api_key"]
GOOGLE_SEARCH_CX = @config["google"]["search_cx"]

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

    results = GoogleCustomSearchApi.search(query_string)
    if @search_numbers < elements_number
      @search_numbers = @search_numbers + 1
      results["items"].first(elements_number).each do |item|
        if !@responses.any? {|r| r[:link] == item["link"] }
          @responses << {title: item["title"], link: item["link"]}
        end
      end    
      @responses.each do |response|
        search_depth(response[:title], elements_number)
      end
    end
  end
end