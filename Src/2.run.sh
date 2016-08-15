#!/bin/bash
#SBATCH -p euan,owners
#SBATCH -n 1
#SBATCH --mem=8G
#SBATCH -t 2-00:00:00
#SBATCH --export=ALL
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=cjprybol@stanford.edu
#SBATCH -o slurm-2.simulate_reads.out
singularity exec v0.1.5.img bash 2.simulate_reads.sh
