if [ ! -d ../Data/Fastq ]; then
	mkdir ../Data/Fastq
fi

# To generate the \ escaped command below, at the terminal run the command `parallel --shellquote`
# and then paste in the following target command
# art_illumina --rndSeed 1 --in ../Reference/{1} --paired --len 150 --rcount 10000 --seqSys HS25 --mflen 500 --sdev 20 --noALN --out ../Data/Fastq/{2} && gzip ../Data/Fastq/{2}1.fq && gzip ../Data/Fastq/{2}2.fq
# and press control-D to exit the pasting and it will return the escaped version

parallel --xapply --keep-order --jobs $1 art_illumina\ --rndSeed\ 1\ --in\ ../Reference/\{1\}\ --paired\ --len\ 150\ --rcount\ 10000\ --seqSys\ HS25\ --mflen\ 500\ --sdev\ 20\ --noALN\ --out\ ../Data/Fastq/\{2\}\ \&\&\ gzip\ ../Data/Fastq/\{2\}1.fq\ \&\&\ gzip\ ../Data/Fastq/\{2\}2.fq ::: gencode.v25.transcripts.fa gencode.v25.transcripts.fa gencode.v25.transcripts.fa hg38.fa hg38.fa hg38.fa ::: gencode_10K. gencode_100K. gencode_1M. hg38_10K. hg38_100K. hg38_1M.

# the above expands to execute the following

# art_illumina --rndSeed 1 --in ../Reference/gencode.v25.transcripts.fa --paired --len 150 --rcount 10000 --seqSys HS25 --mflen 500 --sdev 20 --noALN --out ../Data/Fastq/gencode_10K. && gzip ../Data/Fastq/gencode_10K.1.fq && gzip ../Data/Fastq/gencode_10K.2.fq
# art_illumina --rndSeed 1 --in ../Reference/gencode.v25.transcripts.fa --paired --len 150 --rcount 10000 --seqSys HS25 --mflen 500 --sdev 20 --noALN --out ../Data/Fastq/gencode_100K. && gzip ../Data/Fastq/gencode_100K.1.fq && gzip ../Data/Fastq/gencode_100K.2.fq
# art_illumina --rndSeed 1 --in ../Reference/gencode.v25.transcripts.fa --paired --len 150 --rcount 10000 --seqSys HS25 --mflen 500 --sdev 20 --noALN --out ../Data/Fastq/gencode_1M. && gzip ../Data/Fastq/gencode_1M.1.fq && gzip ../Data/Fastq/gencode_1M.2.fq
# art_illumina --rndSeed 1 --in ../Reference/hg38.fa --paired --len 150 --rcount 10000 --seqSys HS25 --mflen 500 --sdev 20 --noALN --out ../Data/Fastq/hg38_10K. && gzip ../Data/Fastq/hg38_10K.1.fq && gzip ../Data/Fastq/hg38_10K.2.fq
# art_illumina --rndSeed 1 --in ../Reference/hg38.fa --paired --len 150 --rcount 10000 --seqSys HS25 --mflen 500 --sdev 20 --noALN --out ../Data/Fastq/hg38_100K. && gzip ../Data/Fastq/hg38_100K.1.fq && gzip ../Data/Fastq/hg38_100K.2.fq
# art_illumina --rndSeed 1 --in ../Reference/hg38.fa --paired --len 150 --rcount 10000 --seqSys HS25 --mflen 500 --sdev 20 --noALN --out ../Data/Fastq/hg38_1M. && gzip ../Data/Fastq/hg38_1M.1.fq && gzip ../Data/Fastq/hg38_1M.2.fq
