if [ ! -d ../Data/Kallisto ]; then
	mkdir ../Data/Kallisto
fi

OUT_DIR=../Data/Kallisto/rna."$2"
if [ ! -d $OUT_DIR ]; then
	mkdir $OUT_DIR
fi

kallisto quant -b 100 --seed=1 --plaintext -t $1 -i ../Reference/kallisto_index ../Data/Fastq/rna_1.fq.gz ../Data/Fastq/rna_2.fq.gz -o $OUT_DIR
