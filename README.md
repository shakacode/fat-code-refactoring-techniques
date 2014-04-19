# Refactoring Fat Models, Controllers, and Views Example

This example application covers four Rails Refactoring techniques:
Concerns, Decorators, Presenters, and moving code to models.
It builds on the Ruby on Rails Tutorial: sample application by Michael Hartl:
[*Ruby on Rails Tutorial: Learn Web Development with Rails*](http://railstutorial.org/)

The main lessons are presented several pull requests. Much of the
lesson information is contained in the pull request description.

Please inspect the individual commits, as the final result (tip of the branch)
has several smaller lessons included. And please feel free to comment on the
pull request and/or submit issues.

The branches labeled `rc-` are the final versions developed for my RailsConf 2014 presentation,
titled "Concerns, Decorators, Presenters, Service Objects, Helpers, Help Me Decide!".

Topic      | Branch | Pull Request
-----------|--------|------
Concerns   | rc-concerns | https://github.com/justin808/fat-code-refactoring-techniques/pull/9
Decorators | rc-decorators | https://github.com/justin808/fat-code-refactoring-techniques/pull/10
Presenters | rc-presenters | https://github.com/justin808/fat-code-refactoring-techniques/pull/11
Models rather than Service Objects | rc-business-logic-in-model | https://github.com/justin808/fat-code-refactoring-techniques/pull/12

Note, I originally planned to cover "Service Objects". However, my example of a refactoring the
"Kid Safe Microblogger" actually demonstrated how a Service Object pattern is not needed. Instead,
the lesson is to convert to using core Rails techniques of moving logic to business models. You
can find the prior two refactoring attempts here:

* [Pull 6, Service Objects](https://github.com/justin808/fat-code-refactoring-techniques/pull/6).
* [Pull 7, Focused Controller](https://github.com/justin808/fat-code-refactoring-techniques/pull/7).

# Setup

The command `guard` both runs the tests and the application.
To re-run all tests, in the `guard` console window, type `a<return>`.

This will create a branch called `refactoring-tutorial` where you can follow the examples.


    $ cd /tmp
    $ git clone https://github.com/justin808/fat-code-refactoring-techniques.git
    $ git checkout railsconf-start
    $ git checkout -b refactoring-tutorial
    $ cd fat-code-refactoring-techniques
    $ cp config/database.yml.example config/database.yml
    $ bundle install
    $ bundle exec rake db:migrate
    $ bundle exec rake db:test:prepare
    $ guard

Then, if you want to see the completed application:

    $ git checkout railsconf-finish
    $ bundle install
    $ guard

I would suggest creating your `refactoring-tutorial` branch and then manually applying the commits
in the pull requests, creating your own commits along the way.

At each commit, the tests should continue to pass.
