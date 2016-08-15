#!/bin/bash
#SBATCH --partition euan,owners
#SBATCH --cpus-per-task 16
#SBATCH --mem 48G
#SBATCH --time 2-00:00:00
#SBATCH --export ALL
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --mail-user cjprybol@stanford.edu
#SBATCH --output slurm-6.bwa_align.container.out
singularity exec singularity-manuscript.img bash 6.bwa_align.sh 16 container
