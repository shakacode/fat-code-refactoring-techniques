# Refactoring Fat Models, Controllers, and Views Example

This example application teaches 4 Rails Refactoring techniques:
Concerns, Decorators, Presenters, and Service Objects. It builds on the
Ruby on Rails Tutorial: sample application by Michael Hartl:
[*Ruby on Rails Tutorial: Learn Web Development with Rails*](http://railstutorial.org/)

The main lessons are presented several pull requests. Much of the
lesson information is contained in the pull request description.

Please inspect the individual commits, as the final result (tip of the branch)
has several smaller lessons included. And please feel free to comment on the
pull request and/or submit issues.

Topic      | Pull Request
-----------|--------------
Concerns   | https://github.com/justin808/fat-code-refactoring-techniques/pull/3
Decorators | https://github.com/justin808/fat-code-refactoring-techniques/pull/4
Presenters | https://github.com/justin808/fat-code-refactoring-techniques/pull/5
Service Objects: |  https://github.com/justin808/fat-code-refactoring-techniques/pull/6

# Setup

    $ cd /tmp
    $ git clone https://github.com/justin808/fat-code-refactoring-techniques.git
    $ cd fat-code-refactoring-techniques
    $ cp config/database.yml.example config/database.yml
    $ bundle install
    $ bundle exec rake db:migrate
    $ bundle exec rake db:test:prepare
    $ bundle exec rspec spec/

If you want to see the completed application:

    $ git checkout service_objects
    $ bundle install
    $ bundle exec rake db:migrate
    $ bundle exec rake db:test:prepare
    $ bundle exec rspec spec/

Note, per the commit descriptions, a few of the commits do have failing tests.
