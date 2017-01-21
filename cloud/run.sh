#!/bin/bash

# This is a very simple running script to execute a single container workflow.
# It will install Singularity, pull a container, and use it to run a series of scripts. 
# It was developed to run on Ubuntu 16.04 LTS


#########################################################################################
# Setup and Installation
#########################################################################################

# This is the Github repo with analysis
cd $HOME
git clone https://www.github.com/vsoch/singularity-scientific-example
cd singularity-scientific-example
export BASE=$HOME/singularity-scientific-example

# We assume if we are on local cluster, scratch exists
if [[ ! -d "/scratch/data" ]]; then
    sudo mkdir -p /scratch/data
    sudo chmod -R 777 /scratch/data
fi

# This will be our output/data directory
export WORKDIR=/scratch/data

# Let's export the working directory to return to later
export RUNDIR=$HOME/singularity-scientific-example/cloud

# Let's also make a logs directory to keep
mkdir $RUNDIR/logs

# Setup of time and recording of other analysis data (see TIME.md)
export TIME_LOG=$RUNDIR/logs/stats.log
export TIME='%C\t%E\t%I\t%K\t%M\t%O\t%P\t%U\t%W\t%X\t%e\t%k\t%p\t%r\t%s\t%t\t%w\n'
echo "COMMAND	ELAPSED_TIME_HMS	FS_INPUTS	AVG_MEMORY_KB	  MAX_RES_SIZE_KB	FS_OUTPUTS	PERC_CPU_ALLOCATED	CPU_SECONDS_USED	W_TIMES_SWAPPED	SHARED_TEXT_KB	ELAPSED_TIME_SECONDS	NUMBER_SIGNALS_DELIVERED	AVG_UNSHARED_STACK_SIZE	SOCKET_MSG_RECEIVED	SOCKET_MSG_SENT	AVG_RESIDENT_SET_SIZE	CONTEXT_SWITCHES" > $TIME_LOG

# Run Singularity Analysis
bash $RUNDIR/scripts/runscript_singularity.sh

# Move data to different place, ready for Docker
sudo mv /scratch/data /scratch/singularity
sudo mkdir -p /scratch/data
sudo chmod -R 777 /scratch/data

# Run Docker Analysis 
bash $RUNDIR/scripts/runscript_docker.sh

# Get hashes for all files in each directory
bash $RUNDIR/scripts/summarize_results.sh /scratch/data > $RUNDIR/logs/singularity-files.log # Dockerfiles
bash $RUNDIR/scripts/summarize_results.sh /scratch/singularity > $RUNDIR/logs/docker-files.log # Singularity


