require 'active_support/core_ext/date/calculations'

module TimeLogRobot
  module Toggl
    class Report
      include HTTParty

      attr_accessor :token, :workspace_id, :user_agent

      base_uri 'https://toggl.com/reports/api/v2'

      def initialize
        @token = ENV['TOGGL_TOKEN']
        @workspace_id = ENV['TOGGL_WORKSPACE_ID']
        @user_agent = ENV['TOGGL_USER_AGENT']
      end

      def fetch(since: nil)
        since ||= Date.today.beginning_of_week(:saturday).to_time
        self.class.get('/details', basic_auth: auth, query: query(since))
      end

      private

      def auth
        {
          username: token,
          password: "api_token"
        }
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
