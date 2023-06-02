class Question
  def self.ask_with_follow_up_on_json(
    prompt_proc:,
    gpt_client:,
    initial_question: "\nEnter your question: ",
    num_tries: 1
  )
    print "\n" + initial_question +"\n: "
    input = STDIN.gets.chomp
    puts

    prompt_content = prompt_proc.call(embeddings: Embeddings.get(input))
    prompt = { role: "system", content: prompt_content }
    response = gpt_client.chat("'''#{input}'''", messages: [prompt], stream: false)

    return response unless follow_up_needed(response) || num_tries > 3

    clarification_question = get_clarification_question(response)
    ask_with_follow_up_on_json(
      initial_question: clarification_question,
      prompt_proc: prompt_proc,
      gpt_client: gpt_client,
      num_tries: num_tries + 1,
    )

  end

  def self.follow_up_needed(response)
    clarification = JSON.parse(response)['clarification']
    !!clarification && !clarification.strip.empty?
  rescue
    false
  end

  def self.get_clarification_question(response)
    JSON.parse(response)['clarification']
  rescue StandardError
    puts "Error retrieving clarification question..."
    exit
  end
end
