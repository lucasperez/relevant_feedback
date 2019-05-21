require 'telegram/bot'
require_relative "relevant_feedback"
require 'active_support/all'

@config = YAML.load(File.open("./config.yml"))

token = @config["telegram"]["token"]

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    if (message.text.match(/google+ (.*)/))
      term = message.text.match(/google+ (.*)/).captures
      response = RelevantFeedback.new.search(term, 3)
      text = ""
      response.each do |item|
        text = text + "<b>Título: </b> #{item[:title]} - <b>Link: </b> #{item[:link]}\n"
        text = text + "\n\n"
      end
      text = text + "O que achou do nosso algoritmo? Responda nossa pesquisa : )\n\n"
      text = text + "https://forms.gle/XSVRLGw14rTLdovE9"
      text = text + "\n\n"
      bot.api.send_message(chat_id: message.chat.id, text: text, parse_mode: "html")
    end
  end
end