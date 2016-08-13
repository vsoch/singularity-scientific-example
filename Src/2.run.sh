#!/bin/bash
#SBATCH -p euan,owners
#SBATCH -n 6
#SBATCH --mem=48G
#SBATCH -t 2-00:00:00
#SBATCH --export=ALL
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=cjprybol@stanford.edu
#SBATCH -o slurm-2.simulate_reads.out
singularity exec singularity-manuscript.img bash 2.simulate_reads.sh 6
