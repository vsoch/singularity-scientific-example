if [ ! -d ../Data/Kallisto ]; then
	mkdir ../Data/Kallisto
fi

OUT_DIR=../Data/Kallisto/gencode_1M."$1"_cores
if [ ! -d $OUT_DIR ]; then
	mkdir $OUT_DIR
fi

kallisto quant --seed=1 --plaintext -t $1 -i ../Reference/gencode.v25.transcripts.kallisto_index ../Data/Fastq/gencode_1M.1.fq.gz ../Data/Fastq/gencode_1M.2.fq.gz -o $OUT_DIR
