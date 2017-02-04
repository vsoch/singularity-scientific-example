#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage:"
    echo "./9.family_call_variants.sh [DATADIR]"
    exit
fi

DATADIR=$1
MEM=$2
THREADS=$3

if [ ! -d $DATADIR ]; then
    echo "$DATADIR does not exist! Exiting."
    exit
fi

REFERENCE=$DATADIR/Reference/Homo_sapiens.GRCh38.dna.primary_assembly.fa
RTG_DIR=$DATADIR/RTG

rtg RTG_MEM=$MEM family \
	--output $RTG_DIR/container.trio \
	--template $REFERENCE.sdf \
	--machine-errors illumina \
	--avr-model illumina-wgs.avr \
	--threads $THREADS \
	--son NA24385 \
	--father NA24149 \
	--mother NA24143 \
	$RTG_DIR/container.HG002/alignments.bam \
	$RTG_DIR/container.HG003/alignments.bam \
	$RTG_DIR/container.HG004/alignments.bam
