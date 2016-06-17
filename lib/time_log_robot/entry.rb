module TimeLogRobot
  class Entry
    class << self
      def new(service:, raw_entry:)
        case service
        when 'Toggl'
          Toggl::Entry.new(raw_entry)
        end
      end
    end
  end
end