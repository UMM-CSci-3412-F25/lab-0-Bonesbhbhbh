[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/IDWqfhaE)
# Command line introduction and shell scripting <!-- omit in toc -->

[![Compile tests](../../workflows/Compile%20tests/badge.svg)](../../actions?query=workflow%3A"Compile+tests")
[![Clean tests](../../workflows/Clean%20tests/badge.svg)](../../actions?query=workflow%3A"Clean+tests")
[![Shellcheck](../../workflows/shellcheck/badge.svg)](../../actions?query=workflow%3A"shellcheck")
(These will be marked as "Failing" until you have all the tests passing.)

## Overview

**First and Foremost:**  Please read the **entire** lab before starting.  It's quite possible that some questions that arise while reading the lab are answered
later in the lab. That said... let's get to to it!

This provides a basic introduction to shell programming. If you
use Linux much at all, you'll at least occasionally find yourself needing
to use the shell/command line (i.e., what you get when you open the terminal program). Having experience with the shell is extremely useful, as you often
end up needing to, e.g., `ssh` into a remote, cloud-based system where you won't
have access to the nice GUI tools. This lab provides an introduction to a
variety of important shell tools and how programming/scripting is done
using shell commands.

:warning: Remember to complete the [Command line introduction pre-lab](https://github.com/UMM-CSci-Systems/Command-line-introduction-pre-lab) reading and preparation before this lab begins.

- [Overview](#overview)
- [Introduction](#introduction)
- [Setting up](#setting-up)
- [Write clean code](#write-clean-code)
- [Exercises](#exercises)
  - [First script: Compiling a C program](#first-script-compiling-a-c-program)
    - [Let the tests drive your solution](#let-the-tests-drive-your-solution)
    - [Some non-obvious assumptions that the compiling test script makes](#some-non-obvious-assumptions-that-the-compiling-test-script-makes)
    - [Running your script by hand](#running-your-script-by-hand)
    - [Some notes on compiling a C program](#some-notes-on-compiling-a-c-program)
  - [Second script: Clean up a big directory](#second-script-clean-up-a-big-directory)
    - [Some non-obvious assumptions that the cleaning test script makes](#some-non-obvious-assumptions-that-the-cleaning-test-script-makes)
- [Final Thoughts](#final-thoughts)
- [What to turn in](#what-to-turn-in)

## Introduction

You will need to write a few different scripts for this lab:

- A script to extract the contents of a `tar` archive, and then
  compile and run the C program it contains
- A script to delete a large number of unwanted files, leaving the
  other files in that directory alone

None of these will be very long, but most or all of them will require
you to learn new shell commands or tools. We’ll give you hints and
pointers as to what commands/tools to be using, but you’ll need to
do some digging in the `man` pages and/or searching on-line to find
the details. Don’t bang your head against any piece of this for too
long. If you’ve spent more than 10 minutes on a single part or command,
you probably need to take a break and ask someone (like your instructor)
for some help. On the other side of the coin, however, don’t immediately
give up and ask at every step. Learning how to find and use this sort
of information is an enormously valuable skill, and will be useful
far longer and more often than the details that you’re actually looking
up. So make a bit of an effort, but know when to stop.

This is all structured around the `bash` shell and "standard"
command-line tools like `find` and `grep`. There are a variety of
other shells (e.g., [`fish`](https://fishshell.com/) or
[`zsh`](http://zsh.sourceforge.net/)) and tools
(e.g., [`fd`](https://github.com/sharkdp/fd) and
[`rg`](https://github.com/BurntSushi/ripgrep)),
but those won't necessarily be available on the the random system you
find yourself working on, so we're sticking to the "old standbys".

## Setting up

Before you start writing scripts, you’ll need get a copy of this repository
to work on. This is a two step process:

- First follow the Canvas link (which you've already done) to create
  **your copy** of the repository on GitHub Classroom.
- Then _clone_ **your copy** to the machine you're working on

:warning: **IMPORTANT** :warning: Because of a bug in GitHub's handling
of templates, your copy of the repository _will not work_ as it is. You'll
need to run the following two commands to import the submodule files correctly:

```bash
git submodule init

git submodule update
```

<details>
 <summary>Why do I need to do this?</summary>

 [The `bats-core` version of the Bats testing framework](https://github.com/bats-core/bats-core)
 uses [`git` _submodules_](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
 to include its dependencies
 ([libraries like `bats-file`](https://github.com/bats-core/bats-file))
 in your project.

 A `git` submodule is essentially an entire `git` repository nested inside
 an "outer" `git` repository. In this case your project is the outer,
 containing repository, and things like `bats-file` are the inner,
 contained repository.

 There's a bug in GitHub's new-ish template mechanism (which is what GitHub
 classroom uses to create copies of repositories for students and groups) that
 essentially loses the information that a project has submodule
 dependencies. So until that's fixed you'll need to add those three
 submodules to every lab that uses Bats.

</details>
</br>

If you're working in pairs or larger groups only _one_ of you needs to create
your group's copy in GitHub Classroom, but everyone else will need to join
that team in GitHub Classroom so they have access to their team's project.
Also note that if Pat checks out the project on the first day of lab, and then
later Chris is logged in when you sit down to work on it again, Chris will
need to check out the project. Similarly, if Pat and Chris are working
on different computers, then both of them will need to `clone` a local copy.
It's also crucial that everyone commit and push their
work (perhaps to a branch) at the end of each work session so that it will
accessible to everyone in the team.

You’ll “turn in” your work simply by having it committed to the
repository and pushed to GitHub.
We’ll check it out from there to run and grade it.
We'll obviously need to be able to find your repository to grade it,
so make sure to submit the URL of your repository
using whatever technique is indicated by your instructor.

Be certain to **commit often**, and **frequently trade places as driver
and navigator**. At a minimum you should probably trade every time you solve
a specific problem that comes out of the test script. You should probably
consider committing that often as well.

## Write clean code

Part of this lab's rubric is readability, and shell scripts are notoriously
difficult to read. So remember all the nice habits that you've learned, like
using good variable names and commenting non-obvious commands. It's
worth noting that almost _everything_ in a shell script is non-obvious when
you first see it. While we definitely would _not_ recommend commenting every
line of a program in a language like Java or Python, commenting every
(or nearly every) line in a shell script isn't a bad idea. Students almost
never comment _too much_ on these, so when in doubt comment more rather than
less.

You should make sure you run the `shellcheck` command on your shell
scripts, e.g.,

```bash
    /snap/bin/shellcheck big_clean.sh
```

and heed (or at least ask questions about) any warnings that it generates.

Some resources on shell style:

- [Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
  from Google: This is quite detailed and would be a useful resource if you
  ever have questions about how to handle something in a shell script.
- [bash-coding-style](https://github.com/icy/bash-coding-style): Another
  quite detailed style guide with lots of small, readable examples. (The
  Google guide has fewer examples, and those tend to be longer and more
  complex.)
  - This guide also includes an
    [`examples` directory](https://github.com/icy/bash-coding-style/tree/master/examples)
    that has some nice examples, such as [the `steam.sh` example](https://github.com/icy/bash-coding-style/blob/master/examples/steam.sh)
  - Their suggestions about, e.g., putting an underscore (`_`) at the front
    variable names don't seem all that "standard", so follow your heart on
    those issues.
- Shellcheck's [Gallery of bad code](https://github.com/koalaman/shellcheck#gallery-of-bad-code):
  Goes over a "high priority" subset of things
  that `shellcheck` looks for. It would probably make sense to at least skim this since it's quite concise, and we're using `shellcheck` so the payoff will be fairly direct. They don't actually explain _why_
  these things are bad, though, so feel free to ask questions
  if you're uncertain about something (esp. if it comes up when
  you run `shellcheck`).
- [Good Coding Practices for Bash](https://www.networkworld.com/article/2694433/unix-good-coding-practices-for-bash.html)
  is a nice, concise, readable overview of a number of key practices.
  Unfortunately it's cluttered with tons of annoying ads, so prepare thyself.

---

## Exercises

You should complete the following exercises for this lab, each of which
has tests and relevant files in the indicated sub-directory:

- [ ] [First script: Compiling a C program](#first-script-compiling-a-c-program) (in `compiling`)
- [ ] [Second script: Clean up a big directory](#second-script-clean-up-a-big-directory) (in `cleaning`)

The tests and any relevant files for each part are in the appropriate
sub-directory in this repository:

- `compiling`
- `cleaning`

In each case there are tests written using the [`bats` testing tool for `bash` scripts](https://github.com/sstephenson/bats) in a file called `bats_tests.sh`.
You should be able to run the tests with `bats bats_tests.sh`, and use the testing
results as a guide to the development of your scripts. If you ever find that you
don't understand what the tests are "telling you", definitely ask; they are
there to help you, and if they aren't communicating effectively then they're
not doing their job.

You should get all the tests to pass before you "turn in" your work. Having
the tests pass doesn't guarantee that your scripts are 100% correct, but it's a
strong initial indicator.

### First script: Compiling a C program

The tests and data for this problem are in the `compiling` directory of this project, and the discussion of this problem will all assume that you've `cd`ed into that directory. Your goal is complete the desired
script. This includes at a minimum getting the tests in `bats_tests.sh`
(in the `compiling` directory) to pass.

For this you should write a bash script called `extract_and_compile.sh` that:

- Takes one argument, which is the number that will be used as an argument when you call the C program that you'll be compiling in a bit.
- Extracts the contents of the tar archive `NthPrime.tgz` into the
  current directory.
  - This is a compressed tar file (indicated by
    the `gz`, for `gzip`, in the file extension),
    so you’ll need to uncompress and then extract.
  - You can uncompress with `gunzip` and then extract with `tar`. Even
    better, though, is to use `tar` (with the right flags) to do both
    things in one step.
  - You will almost certainly find the `man` pages
    for `tar` useful.
  - This extraction should create a directory `NthPrime` in your current
    directory; that `NthPrime` directory should contain several `*.c` and
    `*.h` files that can be compiled to create an executable.
- Goes into the `NthPrime` directory that the `tar` extraction created.
- Compiles the C program that was extracted, generating an executable
  called `NthPrime` in the same directory.
  - See below for notes on how to compile a C program with
    the `gcc` compiler.
- Call the resulting executable (`NthPrime`). `NthPrime` requires a single
  number as a command line argument; you should pass it the command line
  argument your script received.

As an example, imagine you are in the directory `/home/chris/lab0` and
your script is called using:

```bash
./extract_and_compile.sh 17
```

Then it should

- Extract the contents of `NthPrime.tgz` into
  the current directory, creating a directory `/home/chris/lab0/NthPrime`
- Compile the files in `/home/chris/lab0/NthPrime` to generate the
  binary `/home/chris/lab0/NthPrime/NthPrime`.
- Run that binary with the argument `17` (the first argument in
  this example); this should generate the output `Prime 17 = 59.`

:exclamation: When you run the program you compiled (`NthPrime`) you need give
`NthPrime` a single command line argument. The value you should pass it is
the number _your script_ received as _its_ command line argument.

The final file structure in the example above (as
displayed by the `tree` program) should be:

```bash
$ tree .
.
└── NthPrime
    ├── NthPrime
    ├── main.c
    ├── nth_prime.c
    └── nth_prime.h

1 directory, 4 files
```

Please note that if you are using bash on windows (say, perhaps, via the Linux for Windows Subsystem) then you may need to install `gcc` and/or `bats`.  Talk to your instructor about how to do this if the situation arises (the exact installation command depends upon which distribution of linux is installed) 

#### Let the tests drive your solution

Let the provided Bats tests drive your solution. Run `bats bats_tests.sh`
and look at the _first_ failure. What's the simplest thing you can do to
get that test to pass? Look at the source for the tests (in `bats_tests.sh`)
for hints on what to do if a given test fails.

#### Some non-obvious assumptions that the compiling test script makes

The tests require that the `.tgz` version of the tar archive will still
be in the specified directory
when you’re done. This means that if you first `gunzip` and then, in a
separate step, untar, the test is likely to fail since you’ll end up
with a `.tar` file instead of a `.tgz` file. _So you should use the appropriate `tar` flags that uncompress and untar in a single step._

The tests also assume that your script generates _no_
"extraneous" output. If, for example, you use the `-v`
flag with `tar`, you'll generate a bunch of output that
will cause some of the tests to fail. You may want to have
"extra" output as a debugging tool while you're working
on the script, but you'll need to remove all that to get
the tests to pass. This is consistent with standard
practice in Unix shell programming, where most commands
provide little to no output if things went fine, making it
much easier for you to chain them together into more
complex behaviors.

#### Running your script by hand

Remember that you can call your script "by hand" as a debugging aid so
you can see exactly what it's doing and where. So you could do
something like

```bash
./extract_and_compile.sh 8
```

and then go look around and see what your script did. You'll want to clean
up after each test like that (e.g., `rm -rf NthPrime`) to make sure that
your script successfully re-creates `NthPrime` and doesn't "succeed" just
because `NthPrime` was left over from an earlier run. If you lose
`NthPrime.tgz` the command `git restore NthPrime.tgz` will bring it back,
assuming you having committed the deletion.

#### Some notes on compiling a C program

The C compiler in the lab is the Gnu C Compiler: `gcc`.

There are two `.c` files in this program, both of which will need to be
compiled and linked for form an executable. You can do this in a single line (handing gcc both
`.c` files) or you can compile them separately and then link them.

You can tell `gcc` what you want the executable called, or you can take
the default output and rename it.

Most of you have never compiled a C program before, so this might be a
good time to ask me to say a little about how that works. Alternately,
you might see what you can figure out with `man gcc`.

---

### Second script: Clean up a big directory

Your goal here to build a script that removes files that have been marked
for deletion; at a minimum, you want to get the tests in `bats_tests.sh`
to pass and make sure `shellcheck` is happy. For this you should write a
bash script named `big_clean.sh` that:

- Takes one argument, the name of a compressed `tar` archive (`.tgz` file
  that contains the files you'll process.
- Creates a temporary "scratch" directory to do all the work in.
  - Use `mktemp` for this.
  - You want to do the work in a scratch directory so you don't clutter
    up the user's file space with all the files you get by expanding
    the `tar` archive in their directory.
- Extracts the contents of the `tar` archive into the newly created
  scratch directory.
  - There is a command line flag for `tar` that allows you specify where
    the extracted files should go, which is a lot cleaner than extracting
    them "where they stand" and then moving them to the target directory.
    It also ensures that there won't be a conflict with any existing files.
  - This will take a few seconds for `big_dir.tgz` since that has
    over 1000 files in it.
- Removes all the files from the scratch directory (i.e., the files
  that came from your `tar` archive) containing the line “DELETE ME!”, while
  leaving all the others alone.
  - There are quite a few ways to
    do this. The `grep` family of tools is probably the easiest way to
    see if a file has the “DELETE ME!” line. You could then use `xargs`
    to remove the ones that have the line.
  - Or you could use `grep` and a shell
    loop to loop through all the files and remove the ones that have the
    line.
  - Or you could use the `while/read` approach
    described on [this page about properly
    unquoting variables](https://github.com/koalaman/shellcheck/wiki/SC2046).
- Create a _new_ compressed `tar` archive that contains the files in the scratch directory _after_ you've removed the "DELETE ME!" files. The files in the archive should _not_ have the path to the scratch directory in their filenames. The new tar file should have the name `cleaned_...` where the ellipsis is replaced by the name of the original file, e.g., if your original file is `little_dir.tgz` then the newly created file should be called `cleaned_little_dir.tgz`. The commands `basename` and `dirname` might be useful in constructing the desired file name.
  - This is probably the trickiest part of the lab because you have to be in the scratch directory when you create the `tar` archive or you'll end up with the path to the scratch directory in all the file names.
  - It's easy enough to `cd $SCRATCH` or `pushd $SCRATCH` to get to the scratch directory to run the `tar -zcf...` command, but then how do you know where you came from, so you can put the new tar file in the right place? The `pwd` command returns your current working directory, so something like `here=$(pwd)` will capture your current directory in a shell variable called `here` so you can use `$here` later to refer to where you had been.

If we assume that your scratch directory is, for example,
`/tmp/tmp.eMvVweqb`, then after the first step
(uncompressing) the sample tar file `little_dir.tgz`
you should end up with:

```bash
$ tree /tmp/tmp.eMvVweqb/
/tmp/tmp.eMvVweqb/
└── little_dir
    ├── file_0
    ├── file_1
    ├── file_10
    ├── file_11
    ├── file_12
    ├── file_13
    ├── file_14
    ├── file_15
    ├── file_16
    ├── file_17
    ├── file_18
    ├── file_19
    ├── file_2
    ├── file_3
    ├── file_4
    ├── file_5
    ├── file_6
    ├── file_7
    ├── file_8
    └── file_9

1 directory, 20 files
```

Then after deleting the appropriate files, you should
have:

```bash
$ tree /tmp/tmp.eMvVweqb/
/tmp/tmp.eMvVweqb/
└── little_dir
    ├── file_1
    ├── file_10
    ├── file_11
    ├── file_12
    ├── file_15
    ├── file_16
    ├── file_17
    ├── file_18
    ├── file_19
    ├── file_2
    ├── file_3
    ├── file_4
    ├── file_5
    ├── file_6
    ├── file_8
    └── file_9

1 directory, 16 files
```

Finally, after creating the new cleaned tar file
(`cleaned_little_dir.tgz` in this case) your project
 directory should look like:

```bash
$ tree cleaning/
cleaning/
├── bats_tests.sh
├── big_dir.tgz
├── cleaned_little_dir.tgz
└── little_dir.tgz

0 directories, 4 files
```

#### Some non-obvious assumptions that the cleaning test script makes

The tests assume that the `.tgz` version of the tar archive will be in the specified directory
when you’re done. This means that if you first `gunzip` and then, in a
separate step, untar, the test is likely to fail since you’ll end up
with a `.tar` file instead of a `.tgz` file. _So you should use the appropriate `tar` flags that uncompress and untar in a single step._

You should also assume that if you untar `frogs.tgz`
that will result in a directory called `frogs` that
contains the files you need to process. (There's nothing
magic about `tar` that requires this to be true – see
"[Notes on archive structures](notes-on-archive-structures.md)" for more).

You can assume that the first argument
has the form `frogs.tgz` and not some alternative like
`frogs.tar.gz`.

The tests assume that your script generates _no_
"extraneous" output. If, for example, you use the `-v`
flag with `tar`, you'll generate a bunch of output that
will cause some of the tests to fail. You may want to have
"extra" output as a debugging tool while you're working
on the script, but you'll need to remove all that to get
the tests to pass. This is consistent with standard
practice in Unix shell programming, where most commands
provide little to no output if things went fine, making it
much easier for you to chain them together into more
complex behaviors.

## Final Thoughts

Make sure that all your code passes the appropriate tests. Passing the
test will make up the majority of your grade. There will also be a
portion of your grade that will take into account how clean your code
is. Also when we said that you should commit often –- we meant it. Also be
professional and informative about your commit messages; we'll be looking
at them in the grading. Finally, it is easy to overlook important details. If
the test isn’t being passed go back and re-read the directions
*carefully*.

## What to turn in

You'll "turn this in" by committing your work to your GitHub Classroom
copy of  the
project. You should also submit the URL of your repository in whatever way
indicated by your instructor. Remember to make sure you've completed each
of the assigned tasks:

- [ ] First script: Compiling a C program
  - `compiling/extract_and_compile.sh`
- [ ] Second script: Clean up a big directory
  - `cleaning/big_clean.sh`
- [ ] Commit and push your work to GitHub
