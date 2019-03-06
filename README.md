# Refactoring Fat Models, Controllers, and Views Example

[RailsOnMaui Links to slides, talk, etc.](http://www.railsonmaui.com/blog/2014/04/23/railsconf-2014/)

This example application covers four Rails Refactoring techniques:
Concerns, Decorators, Presenters, and moving code to models.
It builds on the Ruby on Rails Tutorial: sample application by Michael Hartl:
[*Ruby on Rails Tutorial: Learn Web Development with Rails*](http://railstutorial.org/).
However, it is changed in that minors cannot post profanity. If you login as
"littlepunk@sugarranchmaui.com", password "foobar", you get the minor profanity
checking behavior. There is no UI for setting a user to be a minor, FYI.

The code is carefully crafted so that the initial code (at branch `railsconf-start`
is relatively "clean". The lessons can thus focus only on the refactoring techniques,
which are presented several pull requests. Much of the lesson information is contained
in the pull request description.

Please inspect the individual commits, as the refactorings are broken up into smaller
staps. The final result, the tip of the branch, contains the full refactoring.
Please feel free to comment on the pull requests and/or submit issues. You may also
contact me directly at [justin@shakacode.com](mailto:justin@shakacode.com).

The branches labeled `rc-` are the final versions developed for my RailsConf 2014 presentation,
titled "Concerns, Decorators, Presenters, Service Objects, Helpers, Help Me Decide!".

Topic      | Branch | Pull Request
-----------|--------|------
Concerns   | rc-concerns | https://github.com/justin808/fat-code-refactoring-techniques/pull/9
Decorators | rc-decorators | https://github.com/justin808/fat-code-refactoring-techniques/pull/10
Presenters | rc-presenters | https://github.com/justin808/fat-code-refactoring-techniques/pull/11
Models rather than Service Objects | rc-business-logic-in-model | https://github.com/justin808/fat-code-refactoring-techniques/pull/15
Split Controllers | rc-split-controller | https://github.com/justin808/fat-code-refactoring-techniques/pull/13
Controller Concerns | rc-controller-concerns | https://github.com/justin808/fat-code-refactoring-techniques/pull/14

Note, I originally planned to cover "Service Objects". However, my example of a refactoring the
"Kid Safe Microblogger" actually demonstrated how a Service Object pattern is not needed. Instead,
the lesson is to convert to using core Rails techniques of moving logic to business models. You
can find the prior two refactoring attempts here:

* [Pull 6, Service Objects](https://github.com/justin808/fat-code-refactoring-techniques/pull/6).
* [Pull 7, Focused Controller](https://github.com/justin808/fat-code-refactoring-techniques/pull/7).

# Setup

The command `guard` both runs the tests and the application.
To re-run all tests, in the `guard` console window, type `a <return>`.

This will create a branch called `refactoring-tutorial` where you can follow the examples.

```bash
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
```

Then, if you want to see the completed application:

```bash
$ git checkout railsconf-finish
$ bundle install
$ guard
```

I would suggest creating your `refactoring-tutorial` branch and then manually applying the commits
in the pull requests, creating your own commits along the way.

At each commit, the tests should continue to pass.

You can simulate the flow of what I'll be doing in the presentation with the git scripts in `bin/git-railsconf.zsh`.

```bash
$ cd <top level of git repo>
$ . bin/git-railsconf.zsh
$ git checkout railsconf-start # you're at the beginning of the refactorings
```

Then you can run this to simulate the first edit:

```bash
$ railsconf-start
```

Take a look at the files that are changed. See the tests pass. Experiment. Then run:

```bash
$ railsconf-advance-history
```

That will move the history forward one step, and the changing files will be in the git index.

*WARNING*: These scripts mercilessly do `git reset --hard`. So beware!
