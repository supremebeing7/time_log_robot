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
          time_entries.each do |raw_entry|
            entry = Toggl::Entry.new(raw_entry)
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
          (log_tags - entry.tags).size < log_tags.size
        end

        def log(entry)
          payload = build_payload(entry)
          response = post("/issue/#{entry.issue_key}/worklog", basic_auth: auth, headers: headers, body: payload)
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

        def print_report
          Reporter.report(errors, logged_count)
        end

        def set_entry_as_logged(entry)
          Toggl::Tagger.update(entry_id: entry.id)
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
            duration_in_seconds: entry.duration_in_seconds,
            comment: entry.comment
          )
        end
      end
    end
  end
end
