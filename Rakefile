require "time"

require "bundler/setup"
Bundler.require(:default)

Dotenv.load("memory.env")

require_relative "lib/embeddings"

task :chat do
  input = ""

  until input == "q"
    print "Enter message (q to quit): "
    input = STDIN.gets.chomp
    puts Embeddings.get(input) unless input == "q"
  end
end

task :upload_docs do
  puts Embeddings.upsert_file("docs/i6765.pdf")
end
