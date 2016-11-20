#!/bin/bash
#SBATCH --partition euan,owners
#SBATCH --cpus-per-task 8
#SBATCH --mem 64G
#SBATCH --time 2-00:00:00
#SBATCH --export ALL
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --mail-user cjprybol@stanford.edu
#SBATCH --output slurm-9.container.out

singularity exec singularity-testing.img bash 9.family_call_variants.sh 64 8 container
