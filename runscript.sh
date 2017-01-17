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

# We assume if we are on local cluster, scratch exists
if [[ ! -d "/scratch/data" ]]; then
    sudo mkdir -p /scratch/data
    sudo chmod -R 777 /scratch/data
fi

# This will be our output/data directory
export WORKDIR=/scratch/data

# Let's export the working directory to return to later
export RUNDIR=$HOME/singularity-scientific-example

# Let's also make a logs directory to keep
mkdir $RUNDIR/logs
export MAIN_LOG=$RUNDIR/logs/main.log

# Setup of time and recording of other analysis data (see TIME.md)
export TIME_LOG=$RUNDIR/logs/stats.log
export TIME="%C\t%E\t%I\t%K\t%M\t%O\t%P\t%U\t%W\t%X\t%e\tk\t%p\t%r\t%s\t%t\t%w\n"
echo "COMMAND\tELAPSED_TIME_HMS\tFS_INPUTS\tAVG_MEMORY_KB\tFS_OUTPUTS\tPERC_CPU_ALLOCATED\tCPU_SECONDS_USED\tW_TIMES_SWAPPED\tSHARED_TEXT_KB\tELAPSED_TIME_SECONDS\tNUMBER_SIGNALS_DELIVERED\tAVG_UNSHARED_STACK_SIZE SOCKET_MSG_RECEIVED\tSOCKET_MSG_SENT\tAVG_RESIDENT_SET_SIZE\tCONTEXT_SWITCHES" > $TIME_LOG

# 1. Install Singularity and dependencies
# If user has sudo, we assume on cloud instance and install. If not,
# we must be on cluster with it.
timeout 2 sudo id && hassudo="true" || hassudo="no"
if [[ $hassudo == "true" ]]; then
   echo "User has sudo, running install/update of Singularity"
   bash $RUNDIR/scripts/install.sh
fi

# Pull our analysis image
singularity pull shub://vsoch/singularity-scientific-example
image=$(ls *.img)
mv $image analysis.img
chmod u+x analysis.img

#########################################################################################
# Data download
#########################################################################################

# Bind $DATADIR to /scratch in the image
singularity exec analysis.img -B $OUTDIR:/scratch/data bash scripts/1.download_data.sh /scratch/data


#########################################################################################
# Analysis
#########################################################################################

/usr/bin/time -a -o $TIME_LOG singularity exec -B $OUTDIR:/scratch/data analysis.img bash $RUNDIR/scripts/2.simulate_reads.sh /scratch/data
/usr/bin/time -a -o $TIME_LOG singularity exec -B $OUTDIR:/scratch/data analysis.img bash $RUNDIR/scripts/3.generate_transcriptome_index.sh /scratch/data
/usr/bin/time -a -o $TIME_LOG singularity exec -B $OUTDIR:/scratch/data analysis.img bash $RUNDIR/scripts/4.quantify_transcripts.sh /scratch/data
/usr/bin/time -a -o $TIME_LOG singularity exec -B $OUTDIR:/scratch/data analysis.img bash $RUNDIR/scripts/5.bwa_index.sh /scratch/data
/usr/bin/time -a -o $TIME_LOG singularity exec -B $OUTDIR:/scratch/data analysis.img bash $RUNDIR/scripts/6.bwa_align.sh /scratch/data
/usr/bin/time -a -o $TIME_LOG singularity exec -B $OUTDIR:/scratch/data analysis.img bash $RUNDIR/scripts/7.prepare_rtg_run.sh /scratch/data
/usr/bin/time -a -o $TIME_LOG singularity exec -B $OUTDIR:/scratch/data analysis.img bash $RUNDIR/scripts/8.map_trio.sh /scratch/data
/usr/bin/time -a -o $TIME_LOG singularity exec -B $OUTDIR:/scratch/data analysis.img bash $RUNDIR/scripts/9.family_call_variants.sh /scratch/data
