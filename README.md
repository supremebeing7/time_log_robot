[![CircleCI](https://circleci.com/gh/supremebeing7/time_log_robot/tree/master.svg?style=svg)](https://circleci.com/gh/supremebeing7/time_log_robot/tree/master)
[![Gem Version](https://badge.fury.io/rb/time_log_robot.svg)](https://badge.fury.io/rb/time_log_robot)
[![Code Climate](https://codeclimate.com/github/supremebeing7/time_log_robot/badges/gpa.svg)](https://codeclimate.com/github/supremebeing7/time_log_robot)
[![Test Coverage](https://codeclimate.com/github/supremebeing7/time_log_robot/badges/coverage.svg)](https://codeclimate.com/github/supremebeing7/time_log_robot/coverage)

# Time Log Robot
***Let the robot do your work time logging.***

                  ,--.    ,--.
                 ((O ))--((O ))
               ,'_`--'____`--'_`.
              _:  ____________  :_
             | | ||::::::::::|| | |
             | | ||::::::::::|| | |
             | | ||::::::::::|| | |
             |_| |/__________\| |_|
               |________________|
            __..-'            `-..__
         .-| : .----------------. : |-.
       ,\ || | |\______________/| | || /.
      /`.\:| | ||  __  __  __  || | |;/,'\
     :`-._\;.| || '--''--''--' || |,:/_.-':
     |    :  | || .----------. || |  :    |
     |    |  | || '----SSt---' || |  |    |
     |    |  | ||   _   _   _  || |  |    |
     :,--.;  | ||  (_) (_) (_) || |  :,--.;
     (`-'|)  | ||______________|| |  (|`-')
      `--'   | |/______________\| |   `--'
             |____________________|
              `.________________,'
               (_______)(_______)
               (_______)(_______)
               (_______)(_______)
               (_______)(_______)
              |        ||        |
              '--------''--------'

This is an integration between project management tools (like JIRA) and time logging apps (like Toggl). Currently, it only works as an import from Toggl into JIRA.

## Installation

    gem install time_log_robot

## Usage

The simplest usage is just to invoke the robot:

    $ time_log_robot

By default, the robot will get all time entries since the previous Saturday. To specify a different time, run it with the optional `--since` flag (Note: the date given must be in YYYY-MM-DD format):

    $ time_log_robot --since 2016-05-01

On start, the robot will ask you for these details:

    TOGGL_TOKEN
    TOGGL_WORKSPACE_ID
    TOGGL_USER_AGENT
    TOGGL_DEFAULT_LOG_TAG
    JIRA_USERNAME
    JIRA_PASSWORD

The robot has a memory like a steel trap, so after you run it the first time, it will remember your configuration settings and you'll never need to enter them again. However, if you enter the wrong info, or need to change it at some point, you can always overwrite the configuration:

    time_log_robot --overwrite

Or, if you want to pop open the internals, the robot saves all configuration in a file in your home directory: `~/.time_log_robot_settings.yml`, so open up that file and edit to your heart's content.

### Configuration

Here are some notes about how to find the appropriate values for those environment variables:

* **TOGGL_TOKEN**: In your Toggl account, go to your profile page and look for the API token at the bottom.
* **TOGGL_WORKSPACE_ID**: This is a little trickier. Your workspaces usually only show a human-readable name to you in Toggl's UI, and here you need the workspace's machine ID. But you can do a curl request to find it like this (replacing **TOGGL_TOKEN** with your token from above):

    `curl -v -u TOGGL_TOKEN:api_token \ -X GET https://www.toggl.com/api/v8/workspaces`

  Look at the result and find the id given for the workspace you want to use.

* **TOGGL_USER_AGENT**: This is your Toggl username, usually your email.
* **TOGGL_DEFAULT_LOG_TAG**: This is the tag name you would like to use for tagging your Toggl time entries as they are logged to JIRA.
* **JIRA_USERNAME**: This is your JIRA username, which is not an email, but usually your email minus the "@domain.com"
* **JIRA_PASSWORD**: I know there's a lot of jargon, but some of these are pretty self-explanatory. :trollface:

### Mapping keys

You can now map JIRA keys to specific phrases so that in your Toggl time entries, you won't need to enter the JIRA key. These mappings are stored by default in a YAML file in your home directory:

    ~/.time_log_robot_mapping.yml

    # Example usage
    # --
    # phrase: JIRA-KEY
    weekly planning: PM-1

With this mapping, when logging time on on Toggl, instead of having to enter "weekly planning [PM-1]", you can just enter "weekly planning" and the robot will get the JIRA key from the `.time_log_robot_mapping.yml` file.

#### Moving the mapping file

If you don't care about keeping your mapping file hidden or out of the way, or if you want it somewhere it can be accessed more easily, feel free to create your own, then just tell the robot where it's located using the `--mapping` flag:

    $ time_log_robot --mapping
    # or `time_log_robot -m`
    Enter your MAPPING_FILE_PATH: /full/path/to/your_mapping_file.yml

### Help

For more details use the help flag:

    $ time_log_robot --help

Or ask for help with the `run` command:

    $ time_log_robot run --help

## Development
To see available rake tasks for development

    $ rake -T

To run the app in IRB for debugging run

    $ rake console

(Note: If you've built the gem and have committed the `.gem` file, none of your `rake` commands will work. You'll need to remove the built gem and commit the deletion.)

## Contributing

Contributions are welcome! See the [Issues](https://github.com/supremebeing7/time_log_robot/issues) for stuff that needs doing, or create a new one if you have an idea and we can discuss. Eventually it would be great to integrate this with other project management and time tracking tools, so if you use something besides JIRA or Toggl and want to build an integration, that would be welcome. (There's some refactoring that needs to be done on the existing code to make this simpler - issues [#15](https://github.com/supremebeing7/time_log_robot/issues/15) and [#16](https://github.com/supremebeing7/time_log_robot/issues/16).)

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write tests for your new code (uses `minitest`)
4. Make sure all tests pass (`rake test`)
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request to Dev

## License

This program is provided under an MIT open source license, read the [MIT-LICENSE.txt](http://github.com/supremebeing7/jira_toggl_importer/blob/master/LICENSE.txt) file for details.


## Copyright

Copyright (c) 2016 Mark J. Lehman
