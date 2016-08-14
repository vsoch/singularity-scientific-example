if [ ! -d ../Data/Kallisto ]; then
	mkdir ../Data/Kallisto
fi

OUT_DIR=../Data/Kallisto/rna."$2"
if [ ! -d $OUT_DIR ]; then
	mkdir $OUT_DIR
fi

kallisto quant --seed=1 --plaintext -t $1 -i ../Reference/kallisto_index ../Data/Fastq/rna_1.fq ../Data/Fastq/rna_2.fq -o $OUT_DIR
