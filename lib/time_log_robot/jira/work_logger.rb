module TimeLogRobot
  module JIRA
    class WorkLogger
      include HTTParty

      base_uri 'https://hranswerlink.atlassian.net/rest/api/2'

      @errors = []
      @logged_count = 0
      @issue_key = nil

      class << self
        attr_accessor :errors, :logged_count, :issue_key

        def log_all(service:, time_entries:)
          time_entries.each do |raw_entry|
            entry = Entry.new(service: service, raw_entry: raw_entry)
            log(entry) unless is_logged?(entry)
          end
          report!
        end

        private

        def username
          ENV['JIRA_USERNAME']
        end

        def password
          ENV['JIRA_PASSWORD']
        end

        def log_tags
          [ENV['TOGGL_DEFAULT_LOG_TAG']]
        end

        def is_logged?(entry)
          (log_tags - entry.tags).size < log_tags.size
        end

        def log(entry)
          payload = build_payload(entry)
          @issue_key = parse_issue_key(entry)
          response = post("/issue/#{issue_key}/worklog", basic_auth: auth, headers: headers, body: payload)
          if response.success?
            print "\e[32m.\e[0m"
            tag!(entry) if should_tag?(entry)
            @logged_count += 1
          else
            print "\e[31mF\e[0m"
            @errors << [entry, response]
            if response.code == 401
              raise UnauthorizedError, "Please check your username and password and try again"
            end
          end
        end
        class UnauthorizedError < Exception; end

        def report!
          Reporter.report(errors, logged_count)
        end

        def tag!(entry)
          Tagger.tag(entry)
        end

        def should_tag?(entry)
          entry.should_tag?
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
          PayloadBuilder.build(
            start: entry.start,
            # Add an extra 30 seconds for rounding to nearest minute instead of always rounding down
            duration_in_seconds: entry.duration_in_seconds + 30,
            comment: entry.comment
          )
        end

        def parse_issue_key(entry)
          IssueKeyParser.parse(entry)
        end
      end
    end
  end
end
