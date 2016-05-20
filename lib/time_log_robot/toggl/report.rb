require 'active_support/core_ext/date/calculations'

module TimeLogRobot
  module Toggl
    class Report
      include HTTParty

      base_uri 'https://toggl.com/reports/api/v2'

      class << self
        def fetch(since: nil)
          since ||= Date.today.beginning_of_week(:saturday).to_time
          response = get('/details', basic_auth: auth, query: query(since))
          if response.success?
            response['data']
          else
            raise FetchError, response['error']
          end
        end
        class FetchError < Exception; end

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

        def workspace_id
          ENV['TOGGL_WORKSPACE_ID']
        end

        def user_agent
          ENV['TOGGL_USER_AGENT']
        end

        def query(since)
          {
            workspace_id: workspace_id,
            user_agent: user_agent,
            since: since
          }
        end
      end
    end
  end
end
