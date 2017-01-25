#!/bin/bash

# This is a very simple running script to execute a single container workflow.
# It will install Singularity, pull a container, and use it to run a series of scripts. 
# It was developed to run on Ubuntu 16.04 LTS

# Setup and installation for system stuffs is done by run.sh, including setting of:

# WORKDIR to be /scratch/data
# RUNDIR to be $HOME/singularity-scientific-example/cloud
# TIME_LOG and TIME output to $RUNDIR/logs/stats.log

# Let's also make a logs directory to keep
export SINGULARITY_LOG=$RUNDIR/logs/singularity.log

#########################################################################################
# Singularity Installation
#########################################################################################

# 1. Install Singularity and dependencies
# If user has sudo, we assume on cloud instance and install. If not,
# we must be on cluster with it.
timeout 2 sudo id && hassudo="true" || hassudo="no"
if [[ $hassudo == "true" ]]; then
   echo "User has sudo, running install/update of Singularity"
   bash $RUNDIR/scripts/install_singularity.sh
fi

# Pull our analysis image
cd $RUNDIR
singularity pull shub://vsoch/singularity-scientific-example
image=$(ls *.img)
mv $image analysis.img
chmod u+x analysis.img

export NUMCORES=$(nproc)
export MEM=32g
export THREADS=8

#########################################################################################
# Data download
#########################################################################################

# Bind $DATADIR to /scratch in the image
/usr/bin/time -a -o $TIME_LOG singularity exec -B /scratch/data analysis.img bash $RUNDIR/scripts/1.download_data.sh /scratch/data > $SINGULARITY_LOG


#########################################################################################
# Analysis
#########################################################################################

/usr/bin/time -a -o $TIME_LOG singularity exec -B /scratch/data analysis.img bash $RUNDIR/scripts/2.simulate_reads.sh /scratch/data >> $SINGULARITY_LOG
/usr/bin/time -a -o $TIME_LOG singularity exec -B /scratch/data analysis.img bash $RUNDIR/scripts/3.generate_transcriptome_index.sh /scratch/data >> $SINGULARITY_LOG
/usr/bin/time -a -o $TIME_LOG singularity exec -B /scratch/data analysis.img bash $RUNDIR/scripts/4.quantify_transcripts.sh /scratch/data $NUMCORES >> $SINGULARITY_LOG
/usr/bin/time -a -o $TIME_LOG singularity exec -B /scratch/data analysis.img bash $RUNDIR/scripts/5.bwa_index.sh /scratch/data >> $SINGULARITY_LOG
/usr/bin/time -a -o $TIME_LOG singularity exec -B /scratch/data analysis.img bash $RUNDIR/scripts/6.bwa_align.sh /scratch/data >> $SINGULARITY_LOG
/usr/bin/time -a -o $TIME_LOG singularity exec -B /scratch/data analysis.img bash $RUNDIR/scripts/7.prepare_rtg_run.sh /scratch/data >> $SINGULARITY_LOG
/usr/bin/time -a -o $TIME_LOG singularity exec -B /scratch/data analysis.img bash $RUNDIR/scripts/8.map_trio.sh /scratch/data $MEM $THREADS >> $SINGULARITY_LOG
/usr/bin/time -a -o $TIME_LOG singularity exec -B /scratch/data analysis.img bash $RUNDIR/scripts/9.family_call_variants.sh /scratch/data $MEM $THREADS >> $SINGULARITY_LOG

# Remove the analysis image
rm analysis.img
