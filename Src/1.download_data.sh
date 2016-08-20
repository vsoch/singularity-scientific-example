#	if [ ! -d ../Data ]; then
#		mkdir ../Data
#	fi
#
#	FASTQ_DIR=../Data/Fastq
#
#	if [ ! -d $FASTQ_DIR ]; then
#		mkdir $FASTQ_DIR
#	fi
#
#	wget -P $FASTQ_DIR ftp://ngs.sanger.ac.uk/production/gencode/rgasp/RGASP1/inputdata/human_fastq/GM12878_2x75_split.tgz
#	tar --directory $FASTQ_DIR -xzf $FASTQ_DIR/GM12878_2x75_split.tgz
#
#	find $FASTQ_DIR/GM12878_2x75_split -name "GM12878_2x75_rep[1-2].lane[1-3]_1.fq" -exec cat {} \; > $FASTQ_DIR/rna_1.fq && gzip $FASTQ_DIR/rna_1.fq
#	find $FASTQ_DIR/GM12878_2x75_split -name "GM12878_2x75_rep[1-2].lane[1-3]_2.fq" -exec cat {} \; > $FASTQ_DIR/rna_2.fq && gzip $FASTQ_DIR/rna_2.fq
#
#	rm -r $FASTQ_DIR/GM12878_2x75_split
#
REF_DIR=../Reference
#
#	if [ ! -d $REF_DIR ]; then
#		mkdir $REF_DIR
#	fi
#
#	wget -P $REF_DIR ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_25/gencode.v25.transcripts.fa.gz
#	gzip -d $REF_DIR/gencode.v25.transcripts.fa.gz
#	wget -P $REF_DIR ftp://ftp.ensembl.org/pub/release-85/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
#	gzip -d $REF_DIR/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
#
#	# url info for AJtrio was taken from this url
#	# https://raw.githubusercontent.com/genome-in-a-bottle/giab_data_indexes/master/AshkenazimTrio/sequence.index.AJtrio_Illumina_2x250bps_06012016
#

FILE_LIST=$(sed '1d' $REF_DIR/sequence.index.AJtrio_Illumina_2x250bps_06012016 | awk '{print $1, $3}' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g')

for f in $FILE_LIST; do

	OUT_DIR=../Data/$(basename $( dirname $( dirname $( dirname $f ) ) ) )
	if [ ! -d $OUT_DIR ]; then
		mkdir $OUT_DIR
	fi

	FILENAME=$OUT_DIR/$(basename $f)
	if [ ! -f $FILENAME ]; then
		wget -P $OUT_DIR $f
	else
		echo "$FILENAME exists, skipping"
	fi
done
