#!/bin/bash
#SBATCH --partition euan
#SBATCH --cpus-per-task 8
#SBATCH --mem 64G
#SBATCH --time 2-00:00:00
#SBATCH --export ALL
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --mail-user cjprybol@stanford.edu
#SBATCH --output slurm-8.host.out

/bin/bash 8.map_trio.sh 64 8 host
