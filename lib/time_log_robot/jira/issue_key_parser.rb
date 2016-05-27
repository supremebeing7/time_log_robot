module TimeLogRobot
  module JIRA
    class IssueKeyParser

      class << self
        def parse(description)
          matches = description.match(/(\[(?<issue_key>[^\]]*)\])/)
          return matches['issue_key'] unless matches.nil?
          get_key_from_key_mapping(description)
        end

        private

        def get_key_from_key_mapping(description)
          if found_key = mappings.keys.find { |key| description.include?(key) }
            mappings[found_key]
          end
        end

        def mappings
          YAML.load_file(keymap_file_path) || {}
        end

        def keymap_file_path
          File.join(TimeLogRobot.root, 'mapping.yml')
        end
      end
    end
  end
end
