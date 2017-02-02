#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage:"
    echo "./1.download_data.sh [DATADIR]"
    exit
fi

DATADIR=$1

if [ ! -d $DATADIR ]; then
    echo "$DATADIR does not exist! Exiting."
    exit
fi

REF_DIR=$DATADIR/Reference
FASTQ_DIR=$DATADIR/Fastq

if [ ! -d $FASTQ_DIR ]; then
    mkdir $FASTQ_DIR
fi

wget -P $FASTQ_DIR ftp://ngs.sanger.ac.uk/production/gencode/rgasp/RGASP1/inputdata/human_fastq/GM12878_2x75_split.tgz
tar --directory $FASTQ_DIR -xzf $FASTQ_DIR/GM12878_2x75_split.tgz

find $FASTQ_DIR/GM12878_2x75_split -name "GM12878_2x75_rep[1-2].lane[1-3]_1.fq" -exec cat {} \; > $FASTQ_DIR/rna_1.fq


gzip $FASTQ_DIR/rna_1.fq


find $FASTQ_DIR/GM12878_2x75_split -name "GM12878_2x75_rep[1-2].lane[1-3]_2.fq" -exec cat {} \; > $FASTQ_DIR/rna_2.fq


gzip $FASTQ_DIR/rna_2.fq


rm -r $FASTQ_DIR/GM12878_2x75_split

## DOWNLOAD REFERENCE GENOMES/SEQUENCES

if [ ! -d $REF_DIR ]; then
    mkdir $REF_DIR
fi

wget -P $REF_DIR ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_25/gencode.v25.transcripts.fa.gz
gzip -d $REF_DIR/gencode.v25.transcripts.fa.gz
wget -P $REF_DIR ftp://ftp.ensembl.org/pub/release-85/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
gzip -d $REF_DIR/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz

## DOWNLOAD FASTQS FOR TRIO

# url info for AJtrio was taken from this url
# https://raw.githubusercontent.com/genome-in-a-bottle/giab_data_indexes/master/AshkenazimTrio/sequence.index.AJtrio_Illumina_2x250bps_06012016

## MERGE AND SUBSET FASTQS FOR TRIO
RTG_DIR=$DATADIR/RTG
if [ ! -d $RTG_DIR ]; then
    mkdir $RTG_DIR
fi

## THESE FILES HAVE BEEN MADE AVAILABLE BY FTP DOWNLOAD
wget https://stanfordmedicine.box.com/shared/static/beky9c9u05xmljtgj4kq9iuik33xqtbq.gz -O $RTG_DIR/HG002.1.10M.fastq.gz
wget https://stanfordmedicine.box.com/shared/static/isod88qhvfy11d3jlxy2hc1am3axhqg9.gz -O $RTG_DIR/HG002.2.10M.fastq.gz
wget https://stanfordmedicine.box.com/shared/static/wu7kn19y16org4sxvp5r7nw25x3kcc18.gz -O $RTG_DIR/HG003.1.10M.fastq.gz
wget https://stanfordmedicine.box.com/shared/static/o2cdwpn55nuw98kmoq5o0ci67ojz4647.gz -O $RTG_DIR/HG003.2.10M.fastq.gz
wget https://stanfordmedicine.box.com/shared/static/sdufnqkmspj4r8sd1h1cskx5sge7t6c4.gz -O $RTG_DIR/HG004.1.10M.fastq.gz
wget https://stanfordmedicine.box.com/shared/static/5h4t29utrxcg9hbyen4lf6v6qid251bk.gz -O $RTG_DIR/HG004.2.10M.fastq.gz
