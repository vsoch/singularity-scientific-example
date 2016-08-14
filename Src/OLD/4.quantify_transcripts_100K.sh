if [ ! -d ../Data/Kallisto ]; then
	mkdir ../Data/Kallisto
fi

OUT_DIR=../Data/Kallisto/rna_100K."$1"_cores
if [ ! -d $OUT_DIR ]; then
	mkdir $OUT_DIR
fi

kallisto quant --seed=1 --plaintext -t $1 -i ../Reference/kallisto_index ../Data/Fastq/rna_100K.1.fq.gz ../Data/Fastq/rna_100K.2.fq.gz -o $OUT_DIR
