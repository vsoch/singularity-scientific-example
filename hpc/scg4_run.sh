#!/bin/bash

# This is a running script to execute a single container workflow.
# It will install Singularity, pull a container, and use it to run a series of scripts.
# It was developed to run on an HPC SGE cluster, scg4.stanford.edu at Stanford

#########################################################################################
# Setup and Installation
#########################################################################################

# This is the Github repo with analysis
cd $HOME
git clone https://www.github.com/vsoch/singularity-scientific-example
cd singularity-scientific-example
git clone git@github.com:cjprybol/singularity-testing.git
cd singularity-testing
export BASE=$PWD
# export BASE=$HOME/singularity-testing
export RUNDIR=$BASE/hpc

# for scg4 at stanford
module load singularity/jan2017master

# Analysis parameters
THREADS=8
MEM=32G
RTG_THREADS=16

# We have to specify out output directory on scratch
SCRATCH=/srv/gsfs0/scratch/cjprybol
mkdir $SCRATCH/data

# This will be our output/data directory
export WORKDIR=$SCRATCH/data

# Let's also make a logs directory to keep
mkdir $SCRATCH/logs

# Setup of time and recording of other analysis data (see TIME.md)
export TIME_LOG=$SCRATCH/logs/stats.log
export TIME='%C\t%E\t%K\t%I\t%M\t%O\t%P\t%U\t%W\t%X\t%e\t%k\t%p\t%r\t%s\t%t\t%w\n'
echo -e 'COMMAND\tELAPSED_TIME_HMS\tAVERAGE_MEM\tFS_INPUTS\tMAX_RES_SIZE_KB\tFS_OUTPUTS\tPERC_CPU_ALLOCATED\tCPU_SECONDS_USED\tW_TIMES_SWAPPED\tSHARED_TEXT_KB\tELAPSED_TIME_SECONDS\tNUMBER_SIGNALS_DELIVERED\tAVG_UNSHARED_STACK_SIZE\tSOCKET_MSG_RECEIVED\tSOCKET_MSG_SENT\tAVG_RESIDENT_SET_SIZE\tCONTEXT_SWITCHES' > $TIME_LOG

# Download the container to rundir
cd $SCRATCH/data
singularity pull shub://vsoch/singularity-scientific-example
image=$(ls *.img)
mv $image analysis.img
chmod u+x analysis.img

base="qsub -S /bin/bash -j y -R y -V -w e -m bea -M cjprybol@stanford.edu -l h_vmem=4G"

echo "singularity exec -B $SCRATCH:/scratch $SCRATCH/data/analysis.img /usr/bin/time -a -o /scratch/logs/stats.log bash $BASE/scripts/1.download_data.sh /scratch/data" > $RUNDIR/job1
$base -N job1 $RUNDIR/job1

echo "singularity exec -B $SCRATCH:/scratch $SCRATCH/data/analysis.img /usr/bin/time -a -o /scratch/logs/stats.log bash $BASE/scripts/2.simulate_reads.sh /scratch/data" > $RUNDIR/job2
$base -pe shm $THREADS -N job2 -hold_jid job1 $RUNDIR/job2

echo "singularity exec -B $SCRATCH:/scratch $SCRATCH/data/analysis.img /usr/bin/time -a -o /scratch/logs/stats.log bash $BASE/scripts/3.generate_transcriptome_index.sh /scratch/data" > $RUNDIR/job3
$base -pe shm $THREADS -N job3 -hold_jid job2 $RUNDIR/job3

echo "singularity exec -B $SCRATCH:/scratch $SCRATCH/data/analysis.img /usr/bin/time -a -o /scratch/logs/stats.log bash $BASE/scripts/4.quantify_transcripts.sh /scratch/data $THREADS" > $RUNDIR/job4
$base -pe shm $THREADS -N job4 -hold_jid job3 $RUNDIR/job4

echo "singularity exec -B $SCRATCH:/scratch $SCRATCH/data/analysis.img /usr/bin/time -a -o /scratch/logs/stats.log bash $BASE/scripts/5.bwa_index.sh /scratch/data" > $RUNDIR/job5
$base -pe shm $THREADS -N job5 -hold_jid job4 $RUNDIR/job5

echo "singularity exec -B $SCRATCH:/scratch $SCRATCH/data/analysis.img /usr/bin/time -a -o /scratch/logs/stats.log bash $BASE/scripts/6.bwa_align.sh /scratch/data $THREADS" > $RUNDIR/job6
$base -pe shm $THREADS -N job6 -hold_jid job5 $RUNDIR/job6

echo "singularity exec -B $SCRATCH:/scratch $SCRATCH/data/analysis.img /usr/bin/time -a -o /scratch/logs/stats.log bash $BASE/scripts/7.prepare_rtg_run.sh /scratch/data $MEM" > $RUNDIR/job7
$base -pe shm $RTG_THREADS -N job7 -hold_jid job6 $RUNDIR/job7

echo "singularity exec -B $SCRATCH:/scratch $SCRATCH/data/analysis.img /usr/bin/time -a -o /scratch/logs/stats.log bash $BASE/scripts/8.map_trio.sh /scratch/data $MEM $THREADS" > $RUNDIR/job8
$base -pe shm $RTG_THREADS -N job8 -hold_jid job7 $RUNDIR/job8

echo "singularity exec -B $SCRATCH:/scratch $SCRATCH/data/analysis.img /usr/bin/time -a -o /scratch/logs/stats.log bash $BASE/scripts/9.family_call_variants.sh /scratch/data $MEM $THREADS" > $RUNDIR/job9
$base -pe shm $RTG_THREADS -N job9 -hold_jid job8 $RUNDIR/job9

echo "bash $BASE/scripts/summarize_results.sh $SCRATCH/data > $SCRATCH/logs/singularity-files.log" > $RUNDIR/job10
$base -N job10 -hold_jid job9 $RUNDIR/job10

echo "sed -i '/^$/d' $SCRATCH/logs/singularity-files.log" > $RUNDIR/job11
$base -N job11 -hold_jid job10 $RUNDIR/job11

echo "sed -i '/^$/d' $SCRATCH/logs/stats.log" > $RUNDIR/job12
$base -N job12 -hold_jid job11 $RUNDIR/job12
