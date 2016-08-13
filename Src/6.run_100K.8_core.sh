#!/bin/bash
#SBATCH -p euan,owners
#SBATCH -n 8
#SBATCH --mem=48G
#SBATCH -t 2-00:00:00
#SBATCH --export=ALL
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=cjprybol@stanford.edu
#SBATCH -o bwa_100K.8_core.out
singularity exec singularity-manuscript.img bash 6.bwa_align_100K.sh 8
