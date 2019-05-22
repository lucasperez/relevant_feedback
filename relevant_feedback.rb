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

  def search(query_string, elements_per_search)
    puts "vou começar a buscaa...."
    puts "------------------------------------------"
    search_depth(query_string, elements_per_search)
    return @responses
  end
  
  private

  def search_depth(query_string, elements_per_search)

    results = GoogleCustomSearchApi.search(query_string, lr: "lang_pt")
    
    if @search_numbers < elements_per_search
      @search_numbers = @search_numbers + 1
      
      results["items"].each_with_index do |item, index|        
        if @responses.any? {|r| r[:link] == item["link"] } and index == elements_per_search
          break
        end
        if !@responses.any? {|r| r[:link] == item["link"] }
          @responses << {title: item["title"], link: item["link"]}
        end
      end
      @responses.each do |response|
        search_depth(response[:title], elements_per_search)
      end
    end
  end
end