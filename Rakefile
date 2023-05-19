require "time"

require "bundler/setup"
Bundler.require(:default)

Dotenv.load(".env")

Dir["lib/*.rb"].each { |f| require_relative f }

task :qna do
  print "\nEntry your question: "
  input = STDIN.gets.chomp
  puts

  prompt = {
    role: "system",
    content: Prompt.qna(embeddings: Embeddings.get(input))
  }

  GPTClient.new.chat(input, messages: [prompt], stream: true)
end

task :upload_docs do
  Dir["docs/*"].each { |f| puts Embeddings.upsert_file(f) }
end
