if [ $# -eq 0 ]; then
    echo "\nUsage:"
    echo "./5.bwa_index.sh [DATADIR]"
    exit
else

DATADIR=$1

if [ ! -d $DATADIR ]; then
    echo "$DATADIR does not exist! Exiting."
    exit
fi

bwa index -a bwtsw $DATADIR/Reference/Homo_sapiens.GRCh38.dna.primary_assembly.fa
