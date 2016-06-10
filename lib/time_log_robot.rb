require 'json'
require 'httparty'

module TimeLogRobot
  def self.root
    File.dirname __dir__
  end

  def self.start(since)
    time_entries = fetch_time_entries(since)
    JIRA::WorkLogger.log_all(time_entries: time_entries)
  end

  def self.fetch_time_entries(since)
    if since.nil?
      Toggl::Report.fetch
    else
      Toggl::Report.fetch(since: since)
    end
  end

  def self.envars
    envars_help.keys
  end

  def self.envars_help
    {
      MAPPING_FILE_PATH:
        "This is the path to your mapping file. By default, this file is named `.time_log_robot_mapping.yml` and lives in your home directory.\n\n",

      TOGGL_TOKEN:
        "In your Toggl account, go to your profile page and look for the API token at the bottom.\n\n",

      TOGGL_WORKSPACE_ID:
        "This is a little trickier. Your workspaces usually only show a human-readable name to you in Toggl's UI, and here you need the workspace machine ID. But you can do a curl request to find it like this (replacing TOGGL_TOKEN with your token from above):

        \tcurl -v -u TOGGL_TOKEN:api_token \ -X GET https://www.toggl.com/api/v8/workspaces

        Look at the result and find the id given for the workspace you want to use.\n\n",

      TOGGL_USER_AGENT:
        "This is your Toggl username, usually your email.\n\n",

      TOGGL_DEFAULT_LOG_TAG:
        "This is the tag name you would like to use for tagging your Toggl time entries as they are logged to JIRA.\n\n",

      JIRA_USERNAME:
        "This is your JIRA username, which is not an email, but usually your email minus the '@domain.com'\n\n",

      JIRA_PASSWORD:
        "I know there's a lot of jargon, but some of these are pretty self-explanatory
        ┌─┐
        ┴─┴
        ಠ_ರೃ
      \n"
    }
  end
end
