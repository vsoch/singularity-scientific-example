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
export WORKDIR=/scratch
export DATADIR=/scratch/data

# Let's export the working directory to return to later
export RUNDIR=$HOME/singularity-scientific-example

# Let's also make a logs directory to keep
mkdir $RUNDIR/logs

# 1. Install Singularity and dependencies
# If user has sudo, we assume on cloud instance and install. If not,
# we must be on cluster with it.
timeout 2 sudo id && hassudo="true" || hassudo="no"
if [[ $hassudo == "true" ]]; then
   echo "User has sudo, running install/update of Singularity"
   ./scripts/install.sh
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
singularity run analysis.img -B $DATADIR:/scratch 1.download_data.sh /scratch


#########################################################################################
# Analysis
#########################################################################################

singularity run -B $DATADIR:/scratch analysis.img bash 2.simulate_reads.sh /scratch
singularity run -B $DATADIR:/scratch analysis.img bash 3.generate_transcriptome_index.sh /scratch
singularity run -B $DATADIR:/scratch analysis.img bash 4.quantify_transcripts.sh /scratch
singularity run -B $DATADIR:/scratch analysis.img bash 5.bwa_index.sh /scratch
singularity run -B $DATADIR:/scratch analysis.img bash 6.bwa_align.sh /scratch
singularity run -B $DATADIR:/scratch analysis.img bash 7.prepare_rtg_run.sh /scratch
singularity run -B $DATADIR:/scratch analysis.img bash 8.map_trio.sh /scratch
singularity run -B $DATADIR:/scratch analysis.img bash 9.family_call_variants.sh /scratch
singularity run -B $DATADIR:/scratch analysis.img bash


