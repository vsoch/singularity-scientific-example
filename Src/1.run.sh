#!/bin/bash
#SBATCH --partition euan,owners
#SBATCH --cpus-per-task 1
#SBATCH --mem 8G
#SBATCH --time 2-00:00:00
#SBATCH --export ALL
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --mail-user cjprybol@stanford.edu
#SBATCH --output slurm-1.out
singularity exec singularity-manuscript.img bash 1.download_data.sh
