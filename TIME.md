# Time

The standard linux time utility, located at `/usr/bin/time` (sometimes confused with bash time that is first on the path) can be used to assess time, CPU, and memory usage. 

## Format String
We will define a format string, and output to a common file.

The following format string will be used


	export TIMEFMT="%C\t%E\t%I\t%K\t%M\t%O\t%P\t%U\t%W\t%X\t%e\tk\t%p\t%r\t%s\t%t\t%w\n"

## Metrics Collected

With the following header, each command appended to the same file. The following applies:

 - FS: file system
 - AVG: average
 - PERC: percent
 - HMS: hours,minutes,seconds
 - KB: kilobytes
 - MSG: message

 
	COMMAND  ELAPSED_TIME_HMS  FS_INPUTS  AVG_MEMORY_KB  FS_OUTPUTS  PERC_CPU_ALLOCATED  CPU_SECONDS_USED  W_TIMES_SWAPPED  SHARED_TEXT_KB  ELAPSED_TIME_SECONDS  NUMBER_SIGNALS_DELIVERED  AVG_UNSHARED_STACK_SIZE SOCKET_MSG_RECEIVED  SOCKET_MSG_SENT  AVG_RESIDENT_SET_SIZE  CONTEXT_SWITCHES


A complete description of each argument is provided below, from `man time`


              C      Name and command line arguments of the command being
                     timed.
              E      Elapsed real (wall clock) time used by the process, in
                     [hours:]minutes:seconds.
              I      Number of file system inputs by the process.
              K      Average total (data+stack+text) memory use of the
                     process, in Kilobytes.
              M      Maximum resident set size of the process during its
                     lifetime, in Kilobytes.
              O      Number of file system outputs by the process.
              P      Percentage of the CPU that this job got.  This is just
                     user + system times divided by the total running time.
                     It also prints a percentage sign.
              U      Total number of CPU-seconds that the process used
                     directly (in user mode), in seconds.
              W      Number of times the process was swapped out of main
                     memory.
              X      Average amount of shared text in the process, in
                     Kilobytes.
              e      Elapsed real (wall clock) time used by the process, in
                     seconds.
              k      Number of signals delivered to the process.
              p      Average unshared stack size of the process, in Kilobytes.
              r      Number of socket messages received by the process.
              s      Number of socket messages sent by the process.
              t      Average resident set size of the process, in Kilobytes.
              w      Number of times that the program was context-switched
                     voluntarily, for instance while waiting for an I/O

## An Example

	export TIME_LOG=$RUNDIR/logs/stats.log
	/usr/bin/time -a -o $TIMELOG singularity exec -B $OUTDIR:/scratch/data analysis.img bash $RUNDIR/scripts/2.simulate_reads.sh /scratch/data


## How are they different?

I'm going to see if there is any difference between the following:


	time -a -o $TIMELOG singularity exec bash scripts/dostuff.sh
	singularity exec time -a -o $TIMELOG bash scripts/dostuff.sh


One is using the time executable in the container, the other is using the one outside. I have no idea.
