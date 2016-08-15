#!/bin/bash
#SBATCH -p euan,owners
#SBATCH -n 16
#SBATCH --mem=24G
#SBATCH -t 2-00:00:00
#SBATCH --export=ALL
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=cjprybol@stanford.edu
#SBATCH -o slurm-4.quantify_transcripts.container.out
singularity exec v0.1.5.img bash 4.quantify_transcripts.sh 16 container
