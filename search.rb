require 'google_custom_search_api'
require 'terminal-table'

GOOGLE_API_KEY = "AIzaSyBHYSadPQFIbnbgpH0r3NJpDWdARepCzS4"
GOOGLE_SEARCH_CX = "014062119054397272337:4u6z3mq1eoa"

@responses = []

@search_numbers = 0

def search(query_string, elements_number)
  results = GoogleCustomSearchApi.search(query_string, language: "Portuguese")
  if @search_numbers < elements_number
    @search_numbers = @search_numbers + 1
    results["items"].first(elements_number).each do |item|
      @responses << item
    end    
    @responses.each do |response|
      search(response["title"], elements_number)
    end
    
  end
end
query_string = ARGV[0]
elements_number = 3

search(query_string, elements_number)


#MONTANDO A RESPOSTA
rows = []
@responses.each do |item|
  rows << [item["title"], item["link"]]
end

table = Terminal::Table.new :headings => ['Titulo', 'Link'], :rows => rows

puts table