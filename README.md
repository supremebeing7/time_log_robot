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

### Configuration

Here are some notes about how to find the appropriate values for those environment variables:

* **TOGGL_TOKEN**: In your Toggl account, go to your profile page and look for the API token at the bottom.
* **TOGGL_WORKSPACE_ID**: This is a little trickier  You can do a curl request to find it (replacing **TOGGL_TOKEN** with your token value from above):

    `curl -v -u <TOGGL_TOKEN>:api_token https://www.toggl.com/api/v8/workspaces`

    Look at the result at the bottom of the response/`stdout` and find the `id` key and its value:

    ```[{"id":TOGGL_WORKSPACE_ID,"name":"Wreck some code","profile":0,"premium":false,"admin":true,"default_hourly_rate":0,"default_currency":"USD","only_admins_may_create_projects":false,"only_admins_see_billable_rates":false,"only_admins_see_team_dashboard":false,"projects_billable_by_default":true,"rounding":1,"rounding_minutes":0,"api_token":"TOGGL_TOKEN","at":"2016-02-24T01:30:51+00:00","ical_enabled":true}]```


* **TOGGL_USER_AGENT**: This is your Toggl username, usually your email.
* **TOGGL_DEFAULT_LOG_TAG**: This is the tag name you would like to use for tagging your Toggl time entries as they are logged to JIRA.
* **JIRA_USERNAME**: This is your JIRA username, which can be found in your JIRA user profile.
* **JIRA_PASSWORD**: I know there's a lot of jargon, but some of these are pretty self-explanatory. :trollface:

#### Format of time entries

Time entries need an issue key (in JIRA, something like `BUG-12`), a start time, and a duration. The robot will try to parse an issue key from the description first, then from the project name, then from the mapping file (see ["Mapping Keys"](#mapping-keys) section).

For example, all of these are valid:

    This is a bug BUG-15

    (no description) APP-20

    Meeting
    (In project named: ADMIN-123)

##### Comments

Some project management tools also accept comments/descriptions for each time log entry. The robot uses any text within curly braces in the time logging app (Toggl) entry as the description in the project management log entry.

For example:

    This is a bug {This is my comment} BUG-15

If there are no curly braces present, the robot will use the entire description as the comment.

For example:

    This whole description is my comment on issue BUG-20

#### Specifying how far back to log

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

### Automate Your Robot

**_Note: `crontab` only works if the computer is not shut down or asleep._**

Mac and Linux can use `crontab` to set your robot to run on a schedule. You will need to get it running successfully first so all of your credentials are saved.

Next, make a copy of your current `crontab`:

    crontab -l > my-crontab

Then open the `my-crontab` in your favorite editor (e.g. `atom my-crontab`) and add a timing sequence in which to run the robot command. For example, to have the robot run every Saturday at 8AM:

    * 8 * * 6  time_log_robot

(For help in figuring out your timing sequence:)

    *     *     *   *    *        command to be executed
    -     -     -   -    -
    |     |     |   |    |
    |     |     |   |    +----- day of week (0 - 6) (Sunday=0)
    |     |     |   +------- month (1 - 12)
    |     |     +--------- day of        month (1 - 31)
    |     +----------- hour (0 - 23)
    +------------- min (0 - 59)

After editing, save and then “install” your crontab file by giving it to crontab:

    crontab my-crontab

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

To install your local version

    $ rake install

(Note: If you've built the gem using `gem build` and have committed the `.gem` file, none of your `rake` commands will work. You'll need to remove the built gem and commit the deletion.)

## Contributing

Contributions are welcome! See the [Issues](https://github.com/supremebeing7/time_log_robot/issues) for stuff that needs doing, or create a new one if you have an idea and we can discuss. Eventually it would be great to integrate this with other project management and time tracking tools, so if you use something besides JIRA or Toggl and want to build an integration, that would be welcome. (There's some refactoring that needs to be done on the existing code to make this simpler - issue [#18](https://github.com/supremebeing7/time_log_robot/issues/18).)

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
