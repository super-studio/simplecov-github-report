module Formatters
  class Comment
    attr_reader :payload_adapter
    def initialize(payload_adapter:)
      @payload_adapter = payload_adapter
    end

    def as_uri
      "#{Configuration.github_api_url}/#{Configuration.github_comment_path}"
    end

    def as_payload
      {
        body: @payload_adapter.body
      }
    end
  end
end