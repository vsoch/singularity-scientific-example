#!/bin/bash
#SBATCH --partition euan,owners
#SBATCH --cpus-per-task 4
#SBATCH --mem 16G
#SBATCH --time 2-00:00:00
#SBATCH --export ALL
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --mail-user cjprybol@stanford.edu
#SBATCH --output slurm-4.quantify_transcripts.container.out

# 8 cores per cpu * 4 cpu = 32 threads
singularity exec singularity-manuscript.img bash 4.quantify_transcripts.sh 32 container
