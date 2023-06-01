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
  # puts prompt_content

  prompt = { role: "system", content: prompt_content }

  GPTClient.new.chat(input, messages: [prompt], stream: true)
  puts
end

task :four_part do
  print "\nDescribe the product your company sells or the services it provides: \n:"
  input = STDIN.gets.chomp
  puts

  prompt_content = Template.four_part_prompt_1(embeddings: Embeddings.get(input))
  # puts prompt_content

  prompt = { role: "system", content: prompt_content }
  client = GPTClient.new

  puts client.chat(input, messages: [prompt], stream: false)
  puts
end

# task :agent do
#   agent =
#     Patois.new do
#       openai_key ENV["OPENAI_API_KEY"]
#       model "gpt-4"
#
#       prompt Template.agent_prompt
#
#       command :search,
#               description:
#                 "Search the IRS rules and tax codes related to R&D tax credits",
#               handler: ->(query) {
#                 Template.agent_embeddings(embeddings: Embeddings.get(query))
#               }
#     end
#
#   Patois::Runners::CLI.new(agent).run
# end

task :upload_docs do
  Dir["docs/*"].each { |f| puts Embeddings.upsert_file(f) }
end
