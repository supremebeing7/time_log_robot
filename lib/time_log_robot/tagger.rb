module TimeLogRobot
  class Tagger
    class << self
      def tag(entry)
        case entry
        when Toggl::Entry
          Toggl::Tagger.update(entry_id: entry.id)
        end
      end
    end
  end
end