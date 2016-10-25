require_relative '../../test_helper'

module TimeLogRobot
  module Toggl
    class ReportTest < Minitest::Test
      def setup
        @described_class = TimeLogRobot::Toggl::Report
      end

      def test_since_or_default_with_since
        since = DateTime.now - 10
        assert_equal(@described_class.since_or_default(since), since)
      end

      def test_since_or_default_without_since
        Date.stub(:today, Date.new(2016,10,18)) do
          expected_since = Date.new(2016,10,15).to_time
          assert_equal(@described_class.since_or_default(nil), expected_since)
        end
      end
    end
  end
end
