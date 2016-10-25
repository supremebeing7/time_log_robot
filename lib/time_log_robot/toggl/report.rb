module TimeLogRobot
  module Toggl
    class Report
      include HTTParty

      base_uri 'https://toggl.com/reports/api/v2'

      # TODO Refactor to avoid having to pass around `since` so much
      class << self
        def fetch(since: nil)
          since = since_or_default(since)
          response = get('/details', basic_auth: auth, query: query(since))
          if response.success?
            pages = number_of_pages(response['total_count'])
            aggregate_entries(response['data'], pages, since)
          else
            raise FetchError, response['error']
          end
        end
        class FetchError < Exception; end

        def since_or_default(since)
          since || default_since
        end

        private

        def default_since
          # DAYNAMES structure:
          #  ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
          # Therefore saturday index is 6, calculate it anyways incase it changes
          saturday_index = Date::DAYNAMES.index("Saturday")
          today_index = Date.today.wday

          # Return today if it is Saturday (this is what the previous
          # implementation would do)
          return Date.today.to_time if today_index == saturday_index

          # Otherwise, subtract the index + 1 (to account
          # for indecies starting at 0)
          (Date.today - (today_index + 1)).to_time
        end

        def aggregate_entries(entries, pages, since)
          2.upto(pages) do |page|
            entries += get_entries_from_next_page(since, page)
          end
          { service: 'Toggl', entries: entries }
        end

        def get_entries_from_next_page(since, page)
          built_query = query(since).merge(page: page)
          response = get('/details', basic_auth: auth, query: built_query)
          response['data']
        end

        def number_of_pages(count)
          remaining_entries = count % 50
          pages = count / 50
          pages += 1 if remaining_entries > 0
          return pages
        end

        def auth
          {
            username: token,
            password: "api_token"
          }
        end

        def token
          ENV['TOGGL_TOKEN']
        end

        def workspace_id
          ENV['TOGGL_WORKSPACE_ID']
        end

        def user_agent
          ENV['TOGGL_USER_AGENT']
        end

        def query(since)
          {
            workspace_id: workspace_id,
            user_agent: user_agent,
            since: since
          }
        end
      end
    end
  end
end
