module TimeLogRobot
  module JIRA
    class IssueKeyParser
      class << self
        def parse(entry)
          matches = entry['description'].match(/(\[(?<issue_key>[^\]]*)\])/)
          if matches.present?
            matches['issue_key']
          else
            get_key_from_key_mapping(entry['description'])
          end
        end

        private

        def get_key_from_key_mapping(description)
          mappings = YAML.load_file(mapping_file_path) || {}
          if found_key = mappings.keys.find { |key| description.include?(key) }
            mappings[found_key]
          end
        end

        def mapping_file_path
          File.join(TimeLogRobot.root, 'mapping.yml')
        end
      end
    end
  end
end
