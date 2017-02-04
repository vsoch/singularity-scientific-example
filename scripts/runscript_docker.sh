#!/bin/bash

# This is a very simple running script to execute a Docker container workflow.
# It will install Docker, builder an image, and use it to run a series of scripts. 
# It was developed to run on Ubuntu 16.04 LTS

# Setup and installation for system stuffs is done by run.sh, including setting of:

# WORKDIR to be /scratch/data
# RUNDIR to be $HOME/singularity-scientific-example/cloud
# TIME_LOG and TIME output to $RUNDIR/logs/stats.log

#########################################################################################
# Docker Installation
#########################################################################################

# 1. Install Singularity and dependencies
# If user has sudo, we assume on cloud instance and install. If not,
# we must be on cluster with it.
timeout 2 sudo id && hassudo="true" || hassudo="no"
if [[ $hassudo == "true" ]]; then
   echo "User has sudo, running install/update of Docker"
   bash $RUNDIR/scripts/install_docker.sh
fi


#########################################################################################
# Setup and Installation
#########################################################################################

# Build our docker image (not necessary)
# cd $BASE
# docker build -t vanessa/singularity-scientific-example .
cd $RUNDIR

#########################################################################################
# Data download
#########################################################################################

# We already have data downloaded, we are going to do it again.
docker run -v /scratch:/scratch vanessa/singularity-scientific-example /usr/bin/time -a -o $TIME_LOG bash /code/scripts/1.download_data.sh /scratch/data

#########################################################################################
# Analysis
#########################################################################################

docker run -v /scratch:/scratch vanessa/singularity-scientific-example /usr/bin/time -a -o $TIME_LOG bash /code/scripts/2.simulate_reads.sh /scratch/data
docker run -v /scratch:/scratch vanessa/singularity-scientific-example /usr/bin/time -a -o $TIME_LOG bash /code/scripts/3.generate_transcriptome_index.sh /scratch/data
docker run -v /scratch:/scratch vanessa/singularity-scientific-example /usr/bin/time -a -o $TIME_LOG bash /code/scripts/4.quantify_transcripts.sh /scratch/data $NUMCORES
docker run -v /scratch:/scratch vanessa/singularity-scientific-example /usr/bin/time -a -o $TIME_LOG bash /code/scripts/5.bwa_index.sh /scratch/data
docker run -v /scratch:/scratch vanessa/singularity-scientific-example /usr/bin/time -a -o $TIME_LOG bash /code/scripts/6.bwa_align.sh /scratch/data
docker run -v /scratch:/scratch vanessa/singularity-scientific-example /usr/bin/time -a -o $TIME_LOG bash /code/scripts/7.prepare_rtg_run.sh /scratch/data
docker run -v /scratch:/scratch vanessa/singularity-scientific-example /usr/bin/time -a -o $TIME_LOG bash /code/scripts/8.map_trio.sh /scratch/data $MEM $THREADS
docker run -v /scratch:/scratch vanessa/singularity-scientific-example /usr/bin/time -a -o $TIME_LOG bash /code/scripts/9.family_call_variants.sh /scratch/data $MEM $THREADS
