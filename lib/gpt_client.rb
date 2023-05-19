require "erb"

class GPTClient
  MODEL = "gpt-4"

  def initialize
    @client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  end

  def chat(message, messages: [], stream: true)
    messages << { role: "user", content: message }
    parameters = { model: MODEL, messages: messages, temperature: 1 }
    stream_output = ""

    if stream
      parameters[:stream] = proc do |chunk, _bytesize|
        msg = chunk.dig("choices", 0, "delta", "content")
        stream_output << msg if msg
        print msg
      end
    end

    response = @client.chat(parameters: parameters)

    if stream
      puts
      stream_output
    else
      response.dig("choices", 0, "message", "content")
    end
  end
end
