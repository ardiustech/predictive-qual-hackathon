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

    is_a_q = is_a_question(response)
    follow_needed = follow_up_needed(response)

=begin
    print "\n--[debug:]---\n"
    print response + "\n"
    print "is_a_q: #{is_a_q}\n"
    print "follow_needed: #{follow_needed}\n"
    print "-------------\n"
=end

    return response unless is_a_q && follow_needed

    clarification_question = get_clarification_question(response)

    ask_with_follow_up_on_json(
      initial_question: clarification_question,
      prompt_proc: prompt_proc,
      gpt_client: gpt_client,
      num_tries: num_tries + 1,
    )
  end

  def self.is_a_question(response)
    !!JSON.parse(response).dig('is_a_question')
  rescue
    false
  end
  def self.follow_up_needed(response)
    clarification = get_response_clarification(response)

    !!clarification && !clarification.strip.empty?
  rescue
    false
  end

  def self.format_response(response)
    JSON.parse(response)
  end

  def self.get_clarification_question(response)
    get_response_clarification(response)
  rescue StandardError
    puts "Error retrieving clarification question..."
    exit
  end

  def self.get_response_clarification(response)
    format_response(response)['clarification']
  end
end
