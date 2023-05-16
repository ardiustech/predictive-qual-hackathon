require "time"

require "bundler/setup"
Bundler.require(:default)

Dotenv.load(".env")

Dir["lib/*.rb"].each { |f| require_relative f }

task :chat do
  input = ""

  until input == "q"
    puts
    print "Enter message (q to quit): "
    input = STDIN.gets.chomp

    unless input == "q"
      puts
      puts GPTClient.new.chat(input, embeddings: Embeddings.get(input))
    end
  end
end

task :upload_docs do
  puts Embeddings.upsert_file("docs/i6765.pdf")
end
