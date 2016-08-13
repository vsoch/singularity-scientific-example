if [ ! -d ../Data/Bam ]; then
    mkdir ../Data/Bam
fi

bwa mem -M -t $1 ../Reference/hg38.fa ../Data/Fastq/hg38_10K.1.fq.gz ../Data/Fastq/hg38_10K.2.fq.gz | samtools view -bh --threads $1 -o ../Data/Bam/hg38_10K."$1"_core_alignment
