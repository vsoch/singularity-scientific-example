#!/bin/bash
#SBATCH --partition euan,owners
#SBATCH --cpus-per-task 8
#SBATCH --mem 64G
#SBATCH --time 2-00:00:00
#SBATCH --export ALL
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --mail-user cjprybol@stanford.edu
#SBATCH --output slurm-8.container.out

singularity exec singularity-manuscript.img bash 8.map_trio.sh 64 64 container
