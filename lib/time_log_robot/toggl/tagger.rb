module TimeLogRobot
  module Toggl
    class Tagger
      include HTTParty

      attr_accessor :token, :tags

      base_uri 'https://toggl.com/api/v8/time_entries'

      def initialize(tags:[ENV['TOGGL_DEFAULT_LOG_TAG']])
        @token = ENV['TOGGL_TOKEN']
        @tags = tags
      end

      def update(entry_id:)
        self.class.put("/#{entry_id}", basic_auth: auth, headers: headers, body: body)
      end

      private

      def auth
        {
          username: token,
          password: "api_token"
        }
      end

      def headers
        { 'Content-Type' => 'application/json' }
      end

      def body
        {
          time_entry:
          {
            tags: tags
          }
        }.to_json
      end
    end
  end
end
