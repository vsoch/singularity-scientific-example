#!/bin/bash
#SBATCH --partition euan
#SBATCH --cpus-per-task 6
#SBATCH --mem 48G
#SBATCH --time 2-00:00:00
#SBATCH --export ALL
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --mail-user cjprybol@stanford.edu
#SBATCH --output slurm-6.host.out

/bin/bash 6.bwa_align.sh 48 host
