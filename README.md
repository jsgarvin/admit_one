AdmitOne
========

A Ruby lock file manager that is immune to race conditions.

Usage
-----

    AdmitOne::LockFile.new(:lock_name) do
      begin
        # code that needs to run with confidence
        # that the same code isn't also running
        # at the same time in another process
      rescue AdmitOne::LockFailure
        # gracefully recover if the lock could not
        # be established
      end
    end

Installation
------------

    gem install admit_one

Testing
-------

    rake
  
Race Conditions
---------------

All other Ruby lock file libraries I've examined (I'm sure I've missed some,
but hey) are susceptible to race conditions, meaning that there's a tiny
window of opportunity for two separate processes that want the same lock file
to both *think* that they successfully got the lock, defeating the entire
purpose of a lock file.

Usually this is caused by one line of code that checks to see if the lock file
already exists, and if not, a second that creates it. This means two processes
could each, theoretically, check for the file at the same time, both not find
one and think it's safe for each of them to create one, and then both do so,
blissfully ignorant of each other.

Admittedly, this scenario seems highly unlikely, but in some applications
it could result in a complete disaster in a variety of wonderful flavors,
and you're not likely to be creating lock files in the first place unless
it's that very disaster that you absolutely need to prevent.

Solution
--------

AdmitOne solves this problem by taking advantage of how Ruby opens files in
append mode. If the file doesn't already exist, it creates it and then opens
it. Otherwise it just opens it. Then, any writes to the file are appended
to the end. Two processes can open and write to the file at the same time.

AdmitOne appends the process id to the end of file, then reads the first
line in file to compare it's process id with the one on the first line.
In the event of a race condition, two process ids will be written to the
file (remember, append mode), but *only one* can possibly be on the first
line.

The first process will confirm that it's process id is on the first line,
and only then execute your block of code that needed a lock. The second
process will see that the process id on the first line does *not* match
it's own, and instead of executing the code block, will raise an exception
for your application to catch and handle gracefully according to your
preferences (such as trying again later, or triggering a missile launch).

Contributions
-------------

If you can see some way to improve upon this gem, feel free to fork, commit
with tests (if applicable), and then send a pull request. Thank You!