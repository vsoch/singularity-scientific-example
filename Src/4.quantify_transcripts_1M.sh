OUT_DIR=../Data/Kallisto/gencode_1M."$1"_cores
if [ ! -d $OUT_DIR ]; do
	mkdir $OUT_DIR
done

kallisto quant -i ../Reference/gencode.v25.transcripts.kallisto_index ../Data/Fastq/gencode_1M.1.fq.gz ../Data/Fastq/gencode_1M.2.fq.gz -O $OUT_DIR
