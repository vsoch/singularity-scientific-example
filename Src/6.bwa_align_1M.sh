bwa mem -M -t $1 ../Reference/hg38.fa ../Data/Fastq/hg38_1M.1.fq ../Data/Fastq/hg38_1M.2.fq | samtools view -bh --threads $1 -o ../Data/Bam/hg38_1M."$1"_core_alignment
