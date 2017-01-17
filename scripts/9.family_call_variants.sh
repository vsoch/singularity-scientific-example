if [ $# -eq 0 ]; then
    echo "\nUsage:"
    echo "./9.family_call_variants.sh [DATADIR]"
    exit
else

DATADIR=$1

if [ ! -d $DATADIR ]; then
    echo "$DATADIR does not exist! Exiting."
    exit
fi

REFERENCE=$DATADIR/Reference/Homo_sapiens.GRCh38.dna.primary_assembly.fa
RTG_DIR=$DATADIR/RTG
MEM=$(echo "scale=2; $(free | grep 'Mem' | perl -p -e 's/^Mem: +(\d+) .+$/$1/') / 1024^2" | bc)
MEM="$MEM"g

rtg RTG_MEM=$MEM family \
	--output $RTG_DIR/container.trio \
	--template $REFERENCE.sdf \
	--machine-errors illumina \
	--avr-model illumina-wgs.avr \
	--threads 8 \
	--son NA24385 \
	--father NA24149 \
	--mother NA24143 \
	$RTG_DIR/container.HG002/alignments.bam \
	$RTG_DIR/container.HG003/alignments.bam \
	$RTG_DIR/container.HG004/alignments.bam
