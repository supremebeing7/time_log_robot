require_relative '../../test_helper'

module TimeLogRobot
  module JIRA
    class IssueKeyParser
      def self.mappings
        {
          "mapped description" => "HI-5"
        }
      end
    end

    class TestIssueKeyParser < Minitest::Test
      def setup
        @described_class = TimeLogRobot::JIRA::IssueKeyParser
      end

      def test_that_it_gets_the_issue_key
        assert_equal "PM-12", @described_class.parse('description [PM-12]')
      end

      def test_that_it_gives_nothing_with_no_key_present
        assert_equal nil, @described_class.parse('description')
      end

      def test_that_it_fetches_the_key_from_mapping
        assert_equal "HI-5", @described_class.parse('mapped description')
      end

      def test_that_parse_is_not_too_strict_with_mappings
        assert_equal "HI-5", @described_class.parse('mapped description with more text')
      end

      def test_that_parse_mappings_works_with_comments
        assert_equal "HI-5", @described_class.parse('mapped description - {with comment}')
      end
    end
  end
end