#!/bin/bash
#SBATCH --partition euan,owners
#SBATCH --cpus-per-task 1
#SBATCH --mem 48G
#SBATCH --time 2-00:00:00
#SBATCH --export ALL
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --mail-user cjprybol@stanford.edu
#SBATCH --output slurm-5.out
singularity exec singularity-testing.img bash 5.bwa_index.sh
