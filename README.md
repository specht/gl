# gl - command line integration of Git commits and GitLab issues

## Motivation

This is a Linux command line tool that enabled you to link GitLab issues to Git commits. It does so by automatically preparing a commit message every time a commit is performed via a Git hook called `prepare-commit-msg`.

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

Now the commit message will look like this and you're free to append any comments after leaving a blank line:

```
[4] Demo bug

Detailed explanations go here...
# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
# On branch 4-demo-bug
```

Why is this important? Isn't it sufficient to handle issues in topic branches and merge them into the master branch?

Well, Git branches are ephemeral, they're just a pointer into the Git repository. They're just meta-data. They are prone to being moved around and they may be removed at some point the future. Compared to branches, commit messages remain in the Git repository and can't be removed or changed since they're part of the SHA1 sum used for identifying objects in Git.

So after all the work on an issue has been merged into master, there is no way to tell what issue a commit was dealing with if it's not recorded in the commit object, and this is why gl prepends every commit message with an issue ID surrounded by square brackets.

## Tab completion

If you're not into numbers as issue identifiers, feel free to enable BASH tab completion for gl by adding this line to your `~/.bashrc`:

```
complete -C gl -o default gl
```

Now you can switch branches using keywords from the issue titles:

```
$ gl branch dem[TAB]
```

will be expanded to:

```
$ gl branch 4-demo-bug
```
