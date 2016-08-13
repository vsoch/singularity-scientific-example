art_illumina --rndSeed 1 --in ../Reference/hg38.fa --paired --len 150 --rcount 100000 --seqSys HS25 --mflen 500 --sdev 20 --noALN --out ../Data/Fastq/hg38_100K.
gzip ../Data/Fastq/hg38_100K.1.fq
gzip ../Data/Fastq/hg38_100K.2.fq

art_illumina --rndSeed 2 --in ../Reference/hg38.fa --paired --len 150 --rcount 1000000 --seqSys HS25 --mflen 500 --sdev 20 --noALN --out ../Data/Fastq/hg38_1M.
gzip ../Data/Fastq/hg38_1M.1.fq
gzip ../Data/Fastq/hg38_1M.2.fq

art_illumina --rndSeed 3 --in ../Reference/hg38.fa --paired --len 150 --rcount 10000000 --seqSys HS25 --mflen 500 --sdev 20 --noALN --out ../Data/Fastq/hg38_10M.
gzip ../Data/Fastq/hg38_10M.1.fq
gzip ../Data/Fastq/hg38_10M.2.fq

art_illumina --rndSeed 1 --in ../Reference/gencode.v25.transcripts.fa --paired --len 150 --rcount 100000 --seqSys HS25 --mflen 500 --sdev 20 --noALN --out ../Data/Fastq/gencode_100K.
gzip ../Data/Fastq/gencode_100K.1.fq
gzip ../Data/Fastq/gencode_100K.2.fq

art_illumina --rndSeed 2 --in ../Reference/gencode.v25.transcripts.fa --paired --len 150 --rcount 1000000 --seqSys HS25 --mflen 500 --sdev 20 --noALN --out ../Data/Fastq/gencode_1M.
gzip ../Data/Fastq/gencode_1M.1.fq
gzip ../Data/Fastq/gencode_1M.2.fq

art_illumina --rndSeed 3 --in ../Reference/gencode.v25.transcripts.fa --paired --len 150 --rcount 10000000 --seqSys HS25 --mflen 500 --sdev 20 --noALN --out ../Data/Fastq/gencode_10M.
gzip ../Data/Fastq/gencode_10M.1.fq
gzip ../Data/Fastq/gencode_10M.2.fq
