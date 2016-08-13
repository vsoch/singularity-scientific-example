#!/bin/bash
#SBATCH -p euan,owners
#SBATCH -n 8
#SBATCH --mem=48G
#SBATCH -t 2-00:00:00
#SBATCH --export=ALL
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=cjprybol@stanford.edu
#SBATCH -o slurm-6.bwa_1M.8_core.container.out
singularity exec singularity-manuscript.img bash 6.bwa_align_1M.sh 8
