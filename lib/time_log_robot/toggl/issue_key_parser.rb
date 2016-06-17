module TimeLogRobot
  module Toggl
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
