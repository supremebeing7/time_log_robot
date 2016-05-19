# Time Log Robot
***Let the robot do your work time logging.***

This is an integration between project management tools (like JIRA) and time logging apps (like Toggl). Currently, it only works as an import from Toggl into JIRA.

## Installation

~~Download this gem:~~ This is not yet on RubyGems, but once it is, you will be able to download like so:

    gem install time_log_robot

Until then...

    rake install

## Usage

The simplest usage is just to invoke the robot:

    time_log_robot

It will ask you for these details:

    TOGGL_TOKEN
    TOGGL_WORKSPACE_ID
    TOGGL_USER_AGENT
    TOGGL_DEFAULT_LOG_TAG
    JIRA_USERNAME
    JIRA_PASSWORD

Here are some notes about how to find the appropriate values for those environment variables:

* **TOGGL_TOKEN**: In your Toggl account, go to your profile page and look for the API token at the bottom.
* **TOGGL_WORKSPACE_ID**: This is a little trickier. Your workspaces usually only show a human-readable name to you in Toggl's UI, and here you need the workspace's machine ID. But you can do a curl request to find it like this (replacing **TOGGL_TOKEN** with your token from above):

      curl -v -u TOGGL_TOKEN:api_token \ -X GET https://www.toggl.com/api/v8/workspaces

    Look at the result and find the id given for the workspace you want to use.

* **TOGGL_USER_AGENT**: This is your Toggl username, usually your email.
* **TOGGL_DEFAULT_LOG_TAG**: This is the tag name you would like to use for tagging your Toggl time entries as they are logged to JIRA.
* **JIRA_USERNAME**: This is your JIRA username, which is not an email, but usually your email minus the "@domain.com"
* **JIRA_PASSWORD**: I know there's a lot of jargon, but some of these are pretty self-explanatory. :trollface:

For more details use help flag:

    time_log_robot --help


## Development
To see available rake tasks for development

    rake -T

To run the app in IRB for debugging run

    rake console

(Note: If you've built the gem and have committed the `.gem` file, none of your `rake` commands will work. You'll need to remove the built gem and commit the deletion.)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request to Dev