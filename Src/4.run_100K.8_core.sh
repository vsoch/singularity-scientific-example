#!/bin/bash
#SBATCH -p euan,owners
#SBATCH -n 8
#SBATCH --mem=24G
#SBATCH -t 2-00:00:00
#SBATCH --export=ALL
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=cjprybol@stanford.edu
#SBATCH slurm-4.quantify_transcripts_100K.8_core.out
singularity exec singularity-manuscript.img bash 4.quantify_transcripts_100K.sh 8
