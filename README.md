# Contention-Controlled-Scheduling-using-Cgroups-in-Linux
# Author: Phanikar Subodh Krishna Chereddi
# email: pcher003@ucr.edu, subodhkrishnacp@gmail.com

This is an implementation of gang scheduling and contention controlled scheduling in Linux using the Cgroups
With the scripts in this repo you can expirement with different scheduling policies as well

All expirements were conducted in the Ubuntu. The kernel versions used for testing are 4.1 and 4.4
4.4 was the latest kernel at the time of expirement

The machine used is 1 port 4 cores and 2-way hyprthreaded (intle skylake processor). All expirements running only on CPU(GPU-disabled)

gang_run_allcpus.bash :

This script can be configured to run gang scheduling and contention controlled scheduling

PARSEC bench mark suite was used to test the performance and analyse the interference

You may need the Cgroups utility lib to run commands like cgcreate, cgexec, cgdelete
This can be done even with that lib please reed the code which is commented. The PID's need to be echoed into cgroup tasks file.
using cgroup lib has some overhead so, we need to wait for few ms for the PID's to be pushed into tasks file. 
So, manually echoing PID's has better performance

The gang_schedule is the function which can modify the scheduling policy for us.
Ex. if you freeze any process or a cgroup the scheduler cannot see that, i.e. it it no longer a schedulable entity
till it is thawed.

pin_run.bash:

This script uses cgroups to pin a group to a CPU or a group of CPU'S, it ensures that the threads 
are scheduled only on the cpuset specified.

state_check.bash:

This script runs continously on the teminal unless interrupted maually
It continously displays the state of the cgroups (FROZEN, THAWED, FREEZING)
It can be used for debugging.
