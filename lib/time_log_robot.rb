require 'optparse'
require 'optparse/date'
require 'ostruct'
require 'json'
require 'httparty'

module TimeLogRobot
  class << self
    def run(args)
      options = TimeLogRobot.parse(args)

      create_settings_file_if_nonexistent

      fetch_envars_from_config unless options.overwrite

      missing_envars = get_missing_envars
      if options.mapping
        missing_envars['MAPPING_FILE_PATH'] = get_envar('MAPPING_FILE_PATH')
      end

      since = options.since.to_time unless options.since.nil?

      TimeLogRobot.start(since)

      write_missing_envars(missing_envars) if missing_envars.any?
    end

    def parse(args)
      options = OpenStruct.new
      options.mapping   = nil
      options.overwrite = false
      options.since     = nil

      opt_parser = OptionParser.new do |opts|
        opts.separator ''
        opts.banner = 'Usage: time_log_robot [options]'

        opts.separator ''
        opts.separator 'Specific options:'

        opts.separator ''
        opts.on('-m', '--mapping PATH', String,
                'Description to JIRA key mapping file is located by default at',
                '`~/.time_log_robot_mapping.yml`. Use this flag if you have a', 'mapping file elsewhere and would like to define the path to', 'point to your file instead.') do |mapping|
          options.mapping = mapping
        end

        opts.separator ''
        opts.on('-o', '--overwrite',
                'Your settings are automatically written to a file -',
                '`~/.time_log_robot_settings.yml` - to be used again the next', 'time you invoke the robot. Use this flag if you need to', 'overwrite those settings.') do |overwrite|
          options.overwrite = overwrite
        end

        opts.separator ''
        opts.on('-s', '--since DATE', Date,
                'The date from which to log time entries.',
                'Must be in YYYY-MM-DD format.',
                'Default is the previous Saturday.') do |date|
          options.since = date
        end

        opts.separator ''
        opts.separator 'Common options:'

        opts.on_tail('-i', '--inputs_help',
                     'Learn how and where to find the inputs you need to get', 'this working') do
          print_inputs_help
          exit
        end

        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end

        opts.on_tail('-v', '--version', 'Show version') do
          puts TimeLogRobot::VERSION
          exit
        end
      end

      opt_parser.parse!(args)
      options
    end

    def get_missing_envars
      missing_envars = {}

      TimeLogRobot.envars.each do |key|
        next if key == 'MAPPING_FILE_PATH' || ENV[key]
        missing_envars[key] = get_envar(key)
      end

      return missing_envars
    end

    def get_envar(key)
      print "Enter your #{key}: "
      env_value = gets.chomp
      env_value.strip! unless should_not_strip?(key)
      ENV[key] = env_value
      if ENV[key].length == 0
        puts 'Invalid input. This is a required field.'
        exit
      end
      ENV[key]
    end

    def should_not_strip?(key)
      %w(JIRA_PASSWORD).include? key
    end

    def fetch_envars_from_config
      return unless envars = YAML.load_file(settings_file_path)
      envars.each_pair do |key, value|
        value.strip! unless should_not_strip?(key)
        ENV[key.upcase] = value
      end
    end

    def write_missing_envars(missing_envars={})
      puts "\nTo avoid entering setup information each time, the following configuration has been stored in `#{settings_file_path}`:"
      missing_envars.each_pair do |key, value|
        if key =~ /password|token/i
          puts "\t#{key}=[FILTERED]"
        else
          puts "\t#{key}=#{value}"
        end

        data = YAML.load_file(settings_file_path) || {}
        data[key.downcase] = value
        File.open(settings_file_path, 'w') { |f| YAML.dump(data, f) }
      end
    end

    def create_settings_file_if_nonexistent
      File.new(settings_file_path, "w+") unless File.file?(settings_file_path)
    end

    def settings_file_path
      File.join(ENV['HOME'], '.time_log_robot_settings.yml')
    end

    def print_inputs_help
      TimeLogRobot.envars_help.each_pair do |envar, help_text|
        puts envar
        puts help_text
      end
    end

    def root
      File.dirname __dir__
    end

    def start(since)
      report = fetch_time_report(since)
      JIRA::WorkLogger.log_all(
        service: report[:service],
        time_entries: report[:entries]
      )
    end

    def fetch_time_report(since)
      if since.nil?
        Toggl::Report.fetch
      else
        Toggl::Report.fetch(since: since)
      end
    end

    def envars
      envars_help.keys
    end

    def envars_help
      {
        'MAPPING_FILE_PATH' =>
          "This is the path to your mapping file. By default, this file is named `.time_log_robot_mapping.yml` and lives in your home directory.\n\n",

        'TOGGL_TOKEN' =>
          "In your Toggl account, go to your profile page and look for the API token at the bottom.\n\n",

        'TOGGL_WORKSPACE_ID' =>
          "This is a little trickier. Your workspaces usually only show a human-readable name to you in Toggl's UI, and here you need the workspace machine ID. But you can do a curl request to find it like this (replacing TOGGL_TOKEN with your token from above):

          \tcurl -v -u TOGGL_TOKEN:api_token \ -X GET https://www.toggl.com/api/v8/workspaces

          Look at the result and find the id given for the workspace you want to use.\n\n",

        'TOGGL_USER_AGENT' =>
          "This is your Toggl username, usually your email.\n\n",

        'TOGGL_DEFAULT_LOG_TAG' =>
          "This is the tag name you would like to use for tagging your Toggl time entries as they are logged to JIRA.\n\n",

        'JIRA_USERNAME' =>
          "This is your JIRA username, which can be found in your JIRA user profile.\n\n",

        'JIRA_PASSWORD' =>
          "I know there's a lot of jargon, but some of these are pretty self-explanatory\n"
      }
    end
  end
end
