module TimeLogRobot
  module Toggl
    class Entry
      attr_accessor :raw_entry, :issue_key, :duration

      def initialize(raw_entry)
        @raw_entry = raw_entry
      end

      def description
        raw_entry['description']
      end

      def comment
        matches = raw_entry['description'].match(/(\{(?<comment>[^\}]*)\})/)
        matches['comment'] if matches.present?
      end

      def issue_key
        @issue_key ||= IssueKeyParser.parse(description)
      end

      def start
        DateTime.strptime(raw_entry['start'], "%FT%T%:z").strftime("%FT%T.%L%z")
      end

      def duration_in_seconds
        # Toggl sends times in milliseconds
        @duration_in_seconds ||= raw_entry['dur']/1000
      end

      # @TODO This probably belongs on the reporter class?
      def human_readable_duration
        total_minutes = duration_in_seconds/60
        hours = total_minutes/60
        remaining_minutes = total_minutes - hours * 60
        "#{hours}h #{remaining_minutes}m"
      end

      def id
        raw_entry['id']
      end

      def tags
        raw_entry['tags']
      end
    end
  end
end