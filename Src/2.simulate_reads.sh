OUT_DIR="../Data/Fastq"
REF_DIR="../Reference"

if [ ! -d $OUT_DIR ]; then
	mkdir $OUT_DIR
fi

FASTA_FILES=$(find $REF_DIR -type f -name "*.fa")

# parallel --jobs $1 rtg format -f fasta -o {}.sdf {} ::: $FASTA_FILES

TRANSCRIPTOME="$REF_DIR/Homo_sapiens.GRCh38.cdna.all.fa"
GENOME="$REF_DIR/Homo_sapiens.GRCh38.dna.primary_assembly.fa"
REF_FILES="$TRANSCRIPTOME $TRANSCRIPTOME $TRANSCRIPTOME $GENOME $GENOME $GENOME"
OUT_PREFIXES="$OUT_DIR/rna_10K $OUT_DIR/rna_100K $OUT_DIR/rna_1M $OUT_DIR/dna_10K $OUT_DIR/dna_100K $OUT_DIR/dna_1M"
READ_NUMS="10000 100000 1000000"

# parallel --keep-order --xapply --jobs $1 rtg readsim -s 1 -L 75 -R 75 -t {1}.sdf --machine illumina_pe -o {2}.sdf -n {3} ::: $REF_FILES ::: $OUT_PREFIXES ::: $READ_NUMS


parallel rtg sdf2fastq -i {}.sdf -o {}.fq ::: $OUT_PREFIXES

# parallel gzip -dc {} | wc ::: $(find . -name "*.gz")

#
# REF_DIR="../Reference"
# OUT_DIR="../Data/Fastq"
#
# READ_NUMS="10000 100000 1000000"
# REF_FILES="$REF_DIR/Homo_sapiens.GRCh38.cdna.all.fa $REF_DIR/Homo_sapiens.GRCh38.cdna.all.fa $REF_DIR/Homo_sapiens.GRCh38.cdna.all.fa $REF_DIR/Homo_sapiens.GRCh38.dna.primary_assembly.fa $REF_DIR/Homo_sapiens.GRCh38.dna.primary_assembly.fa $REF_DIR/Homo_sapiens.GRCh38.dna.primary_assembly.fa"
# OUT_PREFIXES="$OUT_DIR/rna_10K $OUT_DIR/rna_100K $OUT_DIR/rna_1M $OUT_DIR/dna_10K $OUT_DIR/dna_100K $OUT_DIR/dna_1M"
#
# parallel --xapply --keep-order --jobs $1 \
# art_illumina --rndSeed 1 --in {1} --paired --len 150 --rcount {2} --seqSys HS25 --mflen 300 --sdev 20 --noALN --out {3}. && gzip {3}.1.fq && gzip {3}.2.fq \
# ::: $REF_FILES ::: $READ_NUMS ::: $OUT_PREFIXES
