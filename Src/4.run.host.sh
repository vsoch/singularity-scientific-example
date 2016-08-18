#!/bin/bash
#SBATCH --partition euan,owners
#SBATCH --cpus-per-task 16
#SBATCH --mem 16G
#SBATCH --time 2-00:00:00
#SBATCH --export ALL
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --mail-user cjprybol@stanford.edu
#SBATCH --output slurm-4.quantify_transcripts.host.out

# 8 cores per cpu * # cpu = # threads
/bin/bash 4.quantify_transcripts.sh 128 host
