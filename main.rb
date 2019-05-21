require_relative "relevant_feedback"

term = ARGV[0]
response = RelevantFeedback.new.search(term, 3)

puts response

#MONTANDO A RESPOSTA
rows = []
response.each do |item|
  rows << [item[:title], item[:link]]
end

table = Terminal::Table.new :headings => ['Titulo', 'Link'], :rows => rows

puts table