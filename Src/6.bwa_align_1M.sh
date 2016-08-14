if [ ! -d ../Data/Bam ]; then
    mkdir ../Data/Bam
fi

bwa mem -M -t $1 ../Reference/Homo_sapiens.GRCh38.dna.primary_assembly.fa ../Data/Fastq/dna_1M.1.fq.gz ../Data/Fastq/dna_1M.2.fq.gz | samtools view -bh --threads $1 -o ../Data/Bam/dna_1M."$1"_core_alignment
