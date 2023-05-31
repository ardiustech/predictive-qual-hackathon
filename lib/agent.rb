class Agent
  def self.create
    Patois.new do
      openai_key ENV["OPENAI_API_KEY"]
      model "gpt-4"

      prompt Template.agent_prompt

      command :search,
              description:
                "Search the IRS rules and tax codes related to R&D tax credits",
              handler: ->(query) {
                Template.agent_embeddings(embeddings: Embeddings.get(query))
              }
    end
  end
end
