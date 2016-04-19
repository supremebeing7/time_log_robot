module TimeLogRobot
  module JIRA
    class PayloadBuilder
      attr_accessor :start, :duration_in_seconds, :comment

      def initialize(start:, duration_in_seconds:, comment:)
        @start = start
        @duration_in_seconds = duration_in_seconds
        @comment = comment
      end

      def build
        {
          "comment" => comment,
          "started" => start.to_s,
          "timeSpentSeconds" => duration_in_seconds
        }.to_json
      end
    end
  end
end
