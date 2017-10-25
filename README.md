# gl - command line integration of Git commits and GitLab issues

## Motivation

This is a Linux command line tool that enables you to link GitLab issues to Git commits. It does so by automatically preparing a commit message every time a commit is performed via a Git hook called `prepare-commit-msg`.

Why is this important? Isn't it sufficient to handle issues in topic branches and merge them into the master branch?

Well, Git branches are ephemeral, they're just a pointer into the Git repository. They're just meta-data. They are prone to being moved around and from the perspective of Git, it would be perfectly fine if some branches were entirely removed at some point the future. Compared to branches, commit messages remain in the Git repository and can't be removed or changed since they're part of the SHA1 sum used for identifying objects in Git.

So after all the work on an issue has been merged into master, there is no way to tell what issue a commit was dealing with if it's not recorded in the commit object, and this is why gl prepends every commit message with an issue ID surrounded by square brackets.

### Quick showcase

Let's assume we have the following issue in the GitLab tracker: #4 (Demo bug). 

First, fetch the current issues from the server (try the tab completion, it's pretty useful):

```
$ gl update 
Fetched 5 issues (5 opened).
```

Every now and then, you should re-fetch issues from the GitLab server using `gl update`. All other operations are local operations and don't use the network. 

Let's have a look at the issues:

```
$ gl list
[#1] Basic development
[#2] Documentation
[#3] Add tab completion
[#4] Demo bug
[#5] .gl config file handling
```

Say we're interested in [#4] Demo Bug, let's have a look at the details:

```
$ gl show demo[TAB]
```

...which, if you've set up tab completion, will be completed to:

```
$ gl show 4-demo-bug
---------------------------------------------------------------------------
[#4] Demo bug
---------------------------------------------------------------------------
Labels:   Bug
State:    opened
Created:  2017-10-19
URL:      https://ribogit.izi.fraunhofer.de/michael.specht/gl/issues/4

A strange thing happened...

*Except it didn't. For this is just a demo bug!*
```

Let's start working on the issue:

```
$ gl start 4-demo-bug
Switched to branch '4-demo-bug'
```

When it's time to commit your changes, just add files and commit as usual:

```
$ git commit
```

Now the commit message will look like this and you're free to append any comments after leaving a blank line:

```
[#4] Demo bug

Detailed explanations go here...
# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
# On branch 4-demo-bug
```

## Installation

- Install ActiveSupport: `gem install activesupport`
- Clone the repository
- Run ./gl and follow the instructions to create a symlink.
- You may also want to setup Tab completion for BASH: `complete -C gl -o default gl`
