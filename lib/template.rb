class Template
  def self.qna_prompt(embeddings:)
    template = File.read("templates/qna_prompt.erb")
    ERB.new(template).result(binding)
  end

  def self.agent_prompt
    template = File.read("templates/agent_prompt.erb")
    ERB.new(template).result(binding)
  end

  def self.agent_embeddings(embeddings:)
    template = File.read("templates/agent_embeddings.erb")
    ERB.new(template).result(binding)
  end
end
