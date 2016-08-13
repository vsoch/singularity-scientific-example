#!/bin/bash
#SBATCH -p euan,owners
#SBATCH -n 1
#SBATCH --mem=48G
#SBATCH -t 2-00:00:00
#SBATCH --export=ALL
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=cjprybol@stanford.edu
#SBATCH -o bwa_10K.1_core.out
singularity exec singularity-manuscript.img bash 6.bwa_align_10K.sh 1
