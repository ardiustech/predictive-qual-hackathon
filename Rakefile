require "time"

require "bundler/setup"
Bundler.require(:default)

Dotenv.load(".env")

Dir["lib/*.rb"].each { |f| require_relative f }

four_part_questions = [
  {:question => 'Describe the product your company sells or the services it provides:', :prompt_template => 'four_part_prompt_1'},
  {:question => 'What activities did you perform this year to either create new products and services or improve your existing products or services?', :prompt_template => 'four_part_prompt_2'},
]

task :qna do
  print "\nEnter your question: "
  input = STDIN.gets.chomp
  puts

  prompt_content = Template.qna_prompt(embeddings: Embeddings.get(input))
  # puts prompt_content

  prompt = { role: "system", content: prompt_content }

  GPTClient.new.chat("‘’’#{input}‘’’", messages: [prompt], stream: true)
  puts
end

task :four_part do
  client = GPTClient.new

  four_part_questions.each do |four_part_question|
    Question.ask_with_follow_up_on_json(
      initial_question: four_part_question[:question],
      gpt_client: client,
      prompt_proc: Template.method(four_part_question[:prompt_template].to_s)
    )
  end
end

task :upload_docs do
  Dir["docs/*"].each { |f| puts Embeddings.upsert_file(f) }
end
