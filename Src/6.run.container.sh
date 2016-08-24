#!/bin/bash
#SBATCH --partition euan,owners
#SBATCH --cpus-per-task 4
#SBATCH --mem 64G
#SBATCH --time 2-00:00:00
#SBATCH --export ALL
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --mail-user cjprybol@stanford.edu
#SBATCH --output slurm-6.container.out

singularity exec singularity-manuscript.img bash 6.bwa_align.sh 32 container
