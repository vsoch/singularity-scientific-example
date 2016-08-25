#!/bin/bash
#SBATCH --partition euan,owners
#SBATCH --cpus-per-task 8
#SBATCH --mem 16G
#SBATCH --time 2-00:00:00
#SBATCH --export ALL
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --mail-user cjprybol@stanford.edu
#SBATCH --output slurm-4.container.out

singularity exec singularity-manuscript.img bash 4.quantify_transcripts.sh 8 container
