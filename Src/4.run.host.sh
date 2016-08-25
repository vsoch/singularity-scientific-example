#!/bin/bash
#SBATCH --partition euan,owners
#SBATCH --cpus-per-task 6
#SBATCH --mem 16G
#SBATCH --time 2-00:00:00
#SBATCH --export ALL
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --mail-user cjprybol@stanford.edu
#SBATCH --output slurm-4.host.out

/bin/bash 4.quantify_transcripts.sh 6 host
