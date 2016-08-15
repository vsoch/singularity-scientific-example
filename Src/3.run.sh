#!/bin/bash
#SBATCH -p euan,owners
#SBATCH -n 1
#SBATCH --mem-per-cpu 8G
#SBATCH -t 2-00:00:00
#SBATCH --export ALL
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --mail-user cjprybol@stanford.edu
#SBATCH -o slurm-3.generate_transcriptome_index.out
singularity exec v0.1.5.img bash 3.generate_transcriptome_index.sh
