OUT_DIR=../Data/Kallisto/gencode_100K."$1"_cores
if [ ! -d $OUT_DIR ]; do
	mkdir $OUT_DIR
done

kallisto quant --seed=1 --plaintext -l 500 -t $1 -i ../Reference/gencode.v25.transcripts.kallisto_index ../Data/Fastq/gencode_100K.1.fq.gz ../Data/Fastq/gencode_100K.2.fq.gz -O $OUT_DIR
