#!/bin/bash
#SBATCH -p euan,owners
#SBATCH -n 1
#SBATCH --mem=24G
#SBATCH -t 2-00:00:00
#SBATCH --export=ALL
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=cjprybol@stanford.edu
#SBATCH -o slurm-4.quantify_transcripts_1M.1_core.container.out
singularity exec singularity-manuscript.img bash 4.quantify_transcripts_1M.sh 1
