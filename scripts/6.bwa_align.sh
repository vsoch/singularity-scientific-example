if [ $# -eq 0 ]; then
    echo "\nUsage:"
    echo "./6.bwa_align.sh [DATADIR]"
    exit
fi

DATADIR=$1

if [ ! -d $DATADIR ]; then
    echo "$DATADIR does not exist! Exiting."
    exit
fi

if [ ! -d $DATADIR/Bam ]; then
    mkdir $DATADIR/Bam
fi

bwa mem -t 4 $DATADIR/Reference/Homo_sapiens.GRCh38.dna.primary_assembly.fa $DATADIR/Fastq/dna_1.fq.gz $DATADIR/Fastq/dna_2.fq.gz | samtools view -bhS - > $DATADIR/Bam/container.bam
