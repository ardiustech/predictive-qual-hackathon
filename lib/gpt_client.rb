require "erb"

class GPTClient
  def initialize
    @client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  end

  def prompt(embeddings)
    template = File.read("prompt.erb")
    content = ERB.new(template).result(binding)

    { role: "system", content: content }
  end

  def chat(message, embeddings: [])
    messages = []
    messages << prompt(embeddings) if embeddings.any?
    messages << { role: "user", content: message }

    Timeout.timeout(90) do
      response =
        @client.chat(
          parameters: {
            model: "gpt-4",
            messages: messages,
            temperature: 1
          }
        )

      response.dig("choices", 0, "message", "content")
    end
  end
end
