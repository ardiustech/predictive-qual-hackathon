require "time"

require "bundler/setup"
Bundler.require(:default)

Dotenv.load(".env")

Dir["lib/*.rb"].each { |f| require_relative f }

task :qna do
  print "\nEnter your question: "
  input = STDIN.gets.chomp
  puts

  prompt_content = Template.qna_prompt(embeddings: Embeddings.get(input))
  puts prompt_content

  prompt = { role: "system", content: prompt_content }

  GPTClient.new.chat(input, messages: [prompt], stream: true)
  puts
end

task :agent do
  agent = Agent.create
  Patois::Runners::CLI.new(agent).run
end

task :upload_docs do
  Dir["docs/*"].each { |f| puts Embeddings.upsert_file(f) }
end
