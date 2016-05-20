module TimeLogRobot
  module JIRA
    class PayloadBuilder
      class << self
        def build(start:, duration_in_seconds:, comment:)
          {
            "comment" => comment,
            "started" => start.to_s,
            "timeSpentSeconds" => duration_in_seconds
          }.to_json
        end
      end
    end
  end
end
