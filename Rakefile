require "time"

require "bundler/setup"
Bundler.require(:default)

Dotenv.load("memory.env")

namespace :docs do
  task :upload do
    conn =
      Faraday.new(url: "http://localhost:8080") do |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.adapter :net_http
      end

    req =
      conn.post do |req|
        req.url "/upsert-file"
        req.headers["Content-Type"] = "multipart/form-data"
        req.headers["Authorization"] = "Bearer #{ENV["BEARER_TOKEN"]}"
        req.body = {
          "file" => Faraday::UploadIO.new("docs/i6765.pdf", "application/pdf"),
          "metadata" => {
            url: "16765.pdf",
            source: "file",
            created_at: Time.now.utc.iso8601
          }.to_json
        }
      end

    puts req.body
  end
end
