#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage:"
    echo "./5.bwa_index.sh [DATADIR]"
    exit
fi

DATADIR=$1

if [ ! -d $DATADIR ]; then
    echo "$DATADIR does not exist! Exiting."
    exit
fi

bwa index -a bwtsw $DATADIR/Reference/Homo_sapiens.GRCh38.dna.primary_assembly.fa
