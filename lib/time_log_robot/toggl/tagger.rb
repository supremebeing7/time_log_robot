module TimeLogRobot
  module Toggl
    class Tagger
      include HTTParty

      base_uri 'https://toggl.com/api/v8/time_entries'

      class << self
        def update(entry_id:)
          put("/#{entry_id}", basic_auth: auth, headers: headers, body: body)
        end

        private

        def auth
          {
            username: token,
            password: "api_token"
          }
        end

        def token
          ENV['TOGGL_TOKEN']
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

        def tags
          [ENV['TOGGL_DEFAULT_LOG_TAG']]
        end
      end
    end
  end
end
