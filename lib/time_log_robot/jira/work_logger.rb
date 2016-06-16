module TimeLogRobot
  module JIRA
    class WorkLogger
      include HTTParty

      base_uri 'https://hranswerlink.atlassian.net/rest/api/2'

      @errors = []
      @logged_count = 0

      class << self
        attr_accessor :errors, :logged_count

        def log_all(time_entries:)
          time_entries.each do |entry|
            log(entry) unless is_logged?(entry)
          end
          print_report
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
          (log_tags - entry['tags']).size < log_tags.size
        end

        def log(entry)
          issue_key = parse_issue_key(entry)
          payload = build_payload(entry)
          response = post("/issue/#{issue_key}/worklog", basic_auth: auth, headers: headers, body: payload)
          if response.success?
            print "\e[32m.\e[0m"
            set_entry_as_logged(entry)
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

        def parse_issue_key(entry)
          JIRA::IssueKeyParser.parse(entry['description'])
        end

        def print_report
          print_errors if errors.any?
          puts "\n\t#{logged_count} entries logged, #{errors.size} failed.\n\n"
        end

        def print_errors
          puts "\n\t\e[1;31m Failed to log the following entries:\e[0m"
          errors.each_with_index do |(entry, response), index|
            puts "\e[31m"
            puts "\t#{index + 1})\tDescription: #{entry['description']}"
            if issue_key = parse_issue_key(entry)
              puts "\t\tIssue Key: #{issue_key}"
            else
              puts "\t\tIssue Key: Missing"
            end
            unless parse_comment(entry).nil?
              puts "\t\tComment: #{parse_comment(entry)}"
            end
            puts "\t\t#{human_readable_duration(parse_duration(entry))} starting on #{parse_start(entry)}"
            puts "\t\tResponse Code: #{response.code}"
            puts "\e[0m"
          end
        end

        def set_entry_as_logged(entry)
          Toggl::Tagger.update(entry_id: entry['id'])
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
          JIRA::PayloadBuilder.build(
            start: parse_start(entry),
            duration_in_seconds: parse_duration(entry),
            comment: parse_comment(entry)
          )
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

        def parse_comment(entry)
          matches = entry['description'].match(/(\{(?<comment>[^\}]*)\})/)
          matches['comment'] if matches.present?
        end
      end
    end
  end
end
