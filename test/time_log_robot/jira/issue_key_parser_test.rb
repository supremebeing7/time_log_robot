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
        @entry = OpenStruct.new(description: '', project_name: '')
      end

      def test_that_it_gets_the_issue_key
        @entry.description = 'description [PM-12]'
        assert_equal "PM-12", @described_class.parse(@entry)
      end

      def test_that_it_gives_nothing_with_no_key_present
        @entry.description = 'description'
        assert_equal nil, @described_class.parse(@entry)
      end

      def test_that_it_fetches_the_key_from_mapping
        @entry.description = 'mapped description'
        assert_equal "HI-5", @described_class.parse(@entry)
      end

      def test_that_parse_is_not_too_strict_with_mappings
        @entry.description = 'mapped description with more text'
        assert_equal "HI-5", @described_class.parse(@entry)
      end

      def test_that_parse_mappings_works_with_comments
        @entry.description = 'mapped description - {with comment}'
        assert_equal "HI-5", @described_class.parse(@entry)
      end
    end
  end
end