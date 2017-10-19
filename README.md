# gl - command line integration of Git commits and GitLab issues

## Motivation

This is a Linux command line tool that enabled you to link GitLab issues to Git commits. It does so by automatically preparing a commit message every time a commit is performed via a Git hook.

Let's assume we have the following issue: #4 (Demo bug). 

When you start working on the issue, create a topic branch:

```
$ gl branch 4
Switched to branch '4-demo-bug'
```

When it's time to commit your changes, just add files and commit as usual:

```
$ git commit
```



```
[4] Demo bug

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
# On branch 4-demo-bug
```