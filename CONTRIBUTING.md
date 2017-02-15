Contributing
============

We love pull requests from everyone. By participating in this project, you agree
to abide by the [contributor covenant].

[contributor covenant v1.4]: http://contributor-covenant.org/version/1/4/

Here's a quick guide for contributing:

1. Fork the repo.

1. Run the tests. We only take pull requests with passing tests, and it's great
to know that you have a clean slate: `bundle && bundle exec rake`

1. Add a test for your change. Only refactoring and documentation changes
require no new tests. If you are adding functionality or fixing a bug, we need
a test!

1. Make the test pass.

1. Push to your fork and submit a pull request.

At this point you're waiting on us. We like to at least comment on, if not
accept, pull requests within seven business days. We may suggest some changes or improvements or
alternatives.

Some things that will increase the chance that your pull request is accepted,
taken straight from the Ruby on Rails guide:

* Use Rails idioms and helpers
* Include tests that fail without your code, and pass with it
* Update the documentation, the surrounding one, examples elsewhere, guides,
  whatever is affected by your contribution

Running Tests
-------------

time_log_robot uses [minitest](https://github.com/seattlerb/minitest) for its unit tests. If you submit
tests that are not written for minitest without a very good reason, you
will be asked to rewrite them before we'll accept.

### To run a full test suite:

    bundle exec rake

This will run RSpec and Cucumber against all version of Rails

### To run single test file

    bundle exec rake test TEST=test/test_foobar.rb
    
Syntax
------

Please follow the [Ruby style guide](https://github.com/bbatsov/ruby-style-guide). 
Rubocop will be used on Pull Requests. If you submit code that deviates from this style, 
you will be asked to justify it, and may be asked to change it.
