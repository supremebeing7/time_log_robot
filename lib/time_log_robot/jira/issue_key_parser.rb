module TimeLogRobot
  module JIRA
    class IssueKeyParser
      ISSUE_KEY_REGEX = /([A-Z]+-\d+)/

      class << self
        def parse(entry)
          get_key_from_description(entry.description) ||
          get_key_from_project(entry.project_name) ||
          get_key_from_key_mapping(entry.description)
        end

        private

        def get_key_from_description(description)
          description.match(ISSUE_KEY_REGEX).to_a[1]
        end

        def get_key_from_project(project_name)
          project_name.match(ISSUE_KEY_REGEX).to_a[1]
        end

        def get_key_from_key_mapping(description)
          if found_key = mappings.keys.find { |key| description.include?(key) }
            mappings[found_key]
          end
        end

        def mappings
          YAML.load_file(keymap_file_path) || {}
        rescue Errno::ENOENT
          {}
        end

        def keymap_file_path
          ENV['MAPPING_FILE_PATH'] || default_keymap_file_path
        end

        def default_keymap_file_path
          path = File.join(ENV['HOME'], '.time_log_robot_mapping.yml')
          return path if File.file?(path)
          File.new(path, "w+").path
        end
      end
    end
  end
end
