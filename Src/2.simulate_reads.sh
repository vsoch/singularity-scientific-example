OUT_DIR="../Data/Fastq"
REF_DIR="../Reference"

if [ ! -d $OUT_DIR ]; then
	mkdir $OUT_DIR
fi

GENOME="$REF_DIR/Homo_sapiens.GRCh38.dna.primary_assembly.fa"

READS=100000000
READ_LEN=150
GENOME_SIZE=3400000000
FOLD_COVERAGE=$(python -c "print($READS*$READ_LEN/$GENOME_SIZE)")

art_illumina --rndSeed 1 --in $GENOME --paired --len 75 --fcov $FOLD_COVERAGE --seqSys HS25 --mflen 500 --sdev 20 --noALN --out $OUT_DIR/dna_ && gzip $OUT_DIR/dna_1.fq && gzip $OUT_DIR/dna_2.fq
