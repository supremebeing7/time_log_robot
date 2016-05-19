module TimeLogRobot
  module JIRA
    class WorkLogger
      include HTTParty

      attr_accessor :username, :password, :time_entries, :log_tags

      base_uri 'https://hranswerlink.atlassian.net/rest/api/2'

      def initialize(time_entries:, log_tags: [ENV['TOGGL_DEFAULT_LOG_TAG']])
        @username = ENV['JIRA_USERNAME']
        @password = ENV['JIRA_PASSWORD']
        @time_entries = time_entries
        @log_tags = log_tags
      end

      def log_all
        time_entries.each do |entry|
          log(entry) unless is_logged?(entry)
        end
      end

      private

      def is_logged?(entry)
        (log_tags - entry['tags']).size < log_tags.size
      end

      def log(entry)
        issue_key = parse_issue_key(entry)
        payload = build_payload(entry)
        puts "Attempting to log #{human_readable_duration(parse_duration(entry))}"
        puts "starting on #{parse_start(entry)}"
        puts "to #{entry['description']}"
        puts "with comment #{parse_comment(entry)}" unless parse_comment(entry).nil?
        response = self.class.post("/issue/#{issue_key}/worklog", basic_auth: auth, headers: headers, body: payload)
        if response.success?
          puts "Success"
          puts '*' * 20
          set_entry_as_logged(entry)
        else
          puts "Failed! Response from JIRA:"
          puts response
          puts "(Hint: Did you forget to put the JIRA issue key in your Toggl entry?"
          puts '*' * 20
        end
      end

      def set_entry_as_logged(entry)
        Toggl::Tagger.new(tags: log_tags).update(entry_id: entry['id'])
      end

      def auth
        {
          username: username,
          password: password
        }
      end

      # @TODO Extract since it's used in several different models
      def headers
        { 'Content-Type' => 'application/json' }
      end

      def build_payload(entry)
        JIRA::PayloadBuilder.new(
          start: parse_start(entry),
          duration_in_seconds: parse_duration(entry),
          comment: parse_comment(entry)
        ).build
      end

      def parse_start(entry)
        DateTime.strptime(entry['start'], "%FT%T%:z").strftime("%FT%T.%L%z")
      end

      def parse_duration(entry)
        entry['dur']/1000 # Toggl sends times in milliseconds
      end

      def human_readable_duration(seconds)
        total_minutes = seconds/60
        hours = total_minutes/60
        remaining_minutes = total_minutes - hours * 60
        "#{hours}h #{remaining_minutes}m"
      end

      # @TODO figure out how to capture both of this in one .match call with one set of regex
      def parse_issue_key(entry)
        matches = entry['description'].match(/(\[(?<issue_key>[^\]]*)\])/)
        matches['issue_key'] if matches.present?
      end

      def parse_comment(entry)
        matches = entry['description'].match(/(\{(?<comment>[^\}]*)\})/)
        matches['comment'] if matches.present?
      end
    end
  end
end
