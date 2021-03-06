# Installation instructions

To install Numbat, follow these simple instructions.

## Install MOOSE

Numbat is based on the MOOSE framework, so the first step is to install
MOOSE. For detailed installation instructions depending on your
hardware, see [www.mooseframework.com](http://www.mooseframework.com).

## Clone Numbat

The next step is to clone the Numbat repository to your local machine.

In the following, it is assumed that MOOSE was installed to the
directory `~/projects`. If MOOSE was installed to a different
directory, the following instructions must be modified accordingly.

To clone Numbat, use the following commands

```bash
cd ~/projects
git clone https://github.com/cpgr/numbat.git
cd numbat
git checkout master
```

## Compile Numbat

Next, compile Numbat using

```bash
make -jn
```

where *n* is the number of processing cores on the computer. If
everything has gone well, Numbat should compile without error, producing
a binary named `numbat-opt`.

## Test Numbat

Finally, to test that the installation worked, the test suite can be run
using

```bash
./run_tests -jn
```

where *n* is the number of processing cores on the computer. At this stage, all of
the Numbat tests should have run successfully, and you are ready to run more complicated
simulations, see the [2D examples](example2D.md) and [3D examples](example3D.md) for more details.

## Keep up to date

New features and changes to Numbat may be implemented from time to time. To ensure that
Numbat continues to work without issue, you should make sure that you update your
installation periodically. This can be done using

```bash
git fetch origin
git rebase origin/master
make -jn
./run_tests -jn
```
