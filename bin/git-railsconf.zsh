#!/bin/zsh

# cd to top level of this git repo, then run

# . bin/git-railsconf.zsh

# BE SURE TO SET RAILSCONF_DEMO=<directory of git repo>
export RAILSCONF_DEMO=`pwd`

git-child-sha() {
  branch=${1:-master}
  git log --ancestry-path --format=%H ${commit}..$branch | tail -1
}

git-advance-history() {
  branch=${1:-master}
  sha=$(git-child-sha $branch)
  git --no-pager show --pretty --quiet $sha
  git checkout $sha
}

git-advance-history-reset-soft() {
  branch=${1:-master}
  git reset --hard HEAD
  git-advance-history $branch
  git-advance-history $branch
  git reset --soft HEAD\^
}



# START HERE
railsconf-start() {
  cd $RAILSCONF_DEMO
  git checkout railsconf-start
  git-advance-history railsconf-finish
  git reset --soft HEAD\^
}


# ADVANCE BY USING THIS
# Assumes starting point
# 1. is NOT a branch
# 2. has files checked out
# NOTE: goes a git reset --hard, so you lose any changes!
railsconf-advance-history() {
  git-advance-history-reset-soft railsconf-finish
}


