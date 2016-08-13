wget -P ../Reference ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_25/gencode.v25.transcripts.fa.gz
gzip -d ../Reference/gencode.v25.transcripts.fa.gz
wget -P ../Reference http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz
gzip -d ../Reference/hg38.fa.gz
