module TimeLogRobot
  class Reporter
    class << self
      attr_accessor :errors

      def report(errors, successes)
        @errors = errors
        print_errors if errors.any?
        puts "\n\t#{successes.size} entries logged, #{errors.size} failed.\n\n"
      end

      def print_errors
        puts "\n\t\e[1;31m Failed to log the following entries:\e[0m"
        errors.each_with_index do |(entry, issue_key, response), index|
          puts "\e[31m"
          puts "\t#{index + 1})\tDescription: #{entry.description}"
          if issue_key
            puts "\t\tIssue Key: #{issue_key}"
          else
            puts "\t\tIssue Key: Missing"
          end
          if entry.comment
            puts "\t\tComment: #{entry.comment}"
          end
          puts "\t\t#{entry.human_readable_duration} starting on #{entry.start}"
          puts "\t\tResponse Code: #{response.code}"
          puts "\e[0m"
        end
      end
    end
  end
end