bwa mem -M -t $1 ../Reference/hg38.fa ../Data/Fastq/hg38_1M.1.fq.gz ../Data/Fastq/hg38_1M.2.fq.gz | samtools view -bh --threads $1 -o ../Data/Bam/hg38_1M."$1"_core_alignment
