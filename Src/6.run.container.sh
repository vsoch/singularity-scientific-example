#!/bin/bash
#SBATCH --partition euan,owners
#SBATCH --cpus-per-task 2
#SBATCH --mem 16G
#SBATCH --time 2-00:00:00
#SBATCH --export ALL
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --mail-user cjprybol@stanford.edu
#SBATCH --output slurm-6.bwa_align.container.out

# 8 cores per cpu * 2 cpu = 16 threads
singularity exec singularity-manuscript.img bash 6.bwa_align.sh 16 container
