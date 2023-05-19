class Prompt
  def self.qna(embeddings:)
    template = File.read("prompts/qna.erb")
    ERB.new(template).result(binding)
  end
end
