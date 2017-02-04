#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage:"
    echo "./3.generate_transcriptome_index.sh [DATADIR]"
    exit
fi

DATADIR=$1

if [ ! -d $DATADIR ]; then
    echo "$DATADIR does not exist! Exiting."
    exit
fi

REF_DIR=$DATADIR/Reference

kallisto index $REF_DIR/gencode.v25.transcripts.fa -i $REF_DIR/kallisto_index
