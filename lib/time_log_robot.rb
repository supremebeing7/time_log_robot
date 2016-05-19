require 'json'
require 'httparty'

module TimeLogRobot
  def self.start(since)
    if since.nil?
      time_entries = Toggl::Report.new.fetch['data']
    else
      time_entries = Toggl::Report.new.fetch(since: since)['data']
    end
    logger = JIRA::WorkLogger.new(time_entries: time_entries).log_all
  end
end
