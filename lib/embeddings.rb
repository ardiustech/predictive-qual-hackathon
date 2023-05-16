module Embeddings
  URL = "http://localhost:8080"

  def self.upsert_file(path)
    conn =
      Faraday.new(url: URL) do |faraday|
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
          "file" => Faraday::UploadIO.new(path, "application/pdf"),
          "metadata" => {
            url: path.split("/").last,
            source: "file",
            created_at: Time.now.utc.iso8601
          }.to_json
        }
      end

    req.body
  end

  def self.get(query)
    conn = Faraday.new(url: URL)

    req =
      conn.post do |req|
        req.url "/query"
        req.headers["Content-Type"] = "application/json"
        req.headers["Authorization"] = "Bearer #{ENV["BEARER_TOKEN"]}"
        req.body = { queries: [{ query: query, top_k: 3 }] }.to_json
      end

    req.body
  end
end
