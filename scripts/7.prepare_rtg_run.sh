#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage:"
    echo "./7.prepare_rtf_run.sh [DATADIR]"
    exit
fi

DATADIR=$1

if [ ! -d $DATADIR ]; then
    echo "$DATADIR does not exist! Exiting."
    exit
fi

REFERENCE=$DATADIR/Reference/Homo_sapiens.GRCh38.dna.primary_assembly.fa

rtg format --format fasta --output=$REFERENCE.sdf $REFERENCE
