#!/bin/bash
#SBATCH -p euan,owners
#SBATCH -n 16
#SBATCH --mem=48G
#SBATCH -t 2-00:00:00
#SBATCH --export=ALL
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=cjprybol@stanford.edu
#SBATCH -o slurm-6.bwa_100K.16_core.host.out
singularity exec singularity-manuscript.img bash 6.bwa_align_100K.sh 16
