if [ ! -d ../Data/Bam ]; then
    mkdir ../Data/Bam
fi

bwa mem -t $1 ../Reference/Homo_sapiens.GRCh38.dna.primary_assembly.fa ../Data/Fastq/dna_1.fq.gz ../Data/Fastq/dna_2.fq.gz | samtools view -bhS - > ../Data/Bam/"$2".bam
