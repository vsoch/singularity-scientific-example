if [ ! -d ../Data/Fastq ]; then
	mkdir ../Data/Fastq
fi

# To generate the \ escaped command below, at the terminal run the command `parallel --shellquote`
# and then paste in the following target command
# art_illumina --rndSeed 1 --in ../Reference/{1} --paired --len 150 --rcount {2} --seqSys HS25 --mflen 500 --sdev 20 --noALN --out ../Data/Fastq/{3} && gzip ../Data/Fastq/{3}1.fq && gzip ../Data/Fastq/{3}2.fq
# and press control-D to exit the pasting and it will return the escaped version

parallel --xapply --keep-order --jobs $1 art_illumina\ --rndSeed\ 1\ --in\ ../Reference/\{1\}\ --paired\ --len\ 150\ --rcount\ \{2\}\ --seqSys\ HS25\ --mflen\ 500\ --sdev\ 20\ --noALN\ --out\ ../Data/Fastq/\{3\}\ \&\&\ gzip\ ../Data/Fastq/\{3\}1.fq\ \&\&\ gzip\ ../Data/Fastq/\{3\}2.fq ::: gencode.v25.transcripts.fa gencode.v25.transcripts.fa gencode.v25.transcripts.fa hg38.fa hg38.fa hg38.fa ::: 10000 100000 1000000 ::: gencode_10K. gencode_100K. gencode_1M. hg38_10K. hg38_100K. hg38_1M.
