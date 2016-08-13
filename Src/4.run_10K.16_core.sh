#!/bin/bash
#SBATCH -p euan,owners
#SBATCH -n 16
#SBATCH --mem=24G
#SBATCH -t 2-00:00:00
#SBATCH --export=ALL
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=cjprybol@stanford.edu
#SBATCH slurm-4.quantify_transcripts_10K.16_core.out
singularity exec singularity-manuscript.img bash 4.quantify_transcripts_10K.sh 16
