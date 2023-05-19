require "time"

require "bundler/setup"
Bundler.require(:default)

Dotenv.load(".env")

Dir["lib/*.rb"].each { |f| require_relative f }

task :qna do
  print "\nEnter your question: "
  input = STDIN.gets.chomp
  puts

  prompt = {
    role: "system",
    content: Template.qna_prompt(embeddings: Embeddings.get(input))
  }

  GPTClient.new.chat(input, messages: [prompt], stream: true)
  puts
end

task :agent do
  input = ""
  messages = [{ role: "system", content: Template.agent_prompt }]
  client = GPTClient.new

  loop do
    print "\nEnter your message (q to quit): "
    input = STDIN.gets.chomp
    puts
    puts "-----------------"
    puts

    break if input == "q"

    response = nil

    while response.nil? || response =~ /SEARCH: .*/
      response = client.chat(input, messages: messages, stream: true)
      puts
      puts "-----------------"
      puts

      messages << { role: "user", content: input }
      messages << { role: "system", content: response }

      if response =~ /SEARCH: .*/
        query = response.match(/SEARCH: (.*)/)[1]
        input = Template.agent_embeddings(embeddings: Embeddings.get(query))

        puts input
        puts "-----------------"
        puts
      end
    end
  end
end

task :upload_docs do
  Dir["docs/*"].each { |f| puts Embeddings.upsert_file(f) }
end
