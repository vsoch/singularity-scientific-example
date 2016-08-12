# singularity-manuscript

1. [install singularity](http://singularity.lbl.gov/#install)
1. clone and enter this repository
  - `git clone https://github.com/cjprybol/singularity-manuscript.git && cd singularity-manuscript`
1. download the singularity container used to perform the analysis
  - `wget <url> -O singularity-manuscript.img`
1. run the tests for yourself

```
OUT_DIR="../LaunchTimes"
if [ ! -d $OUT_DIR ]; do
  mkdir $OUT_DIR
done

touch $OUT_DIR/python.txt

for i in 1..10; do
  time python3 100_random_numbers.py >> $OUT_DIR/python_times.txt
done

touch $OUT_DIR/R.txt

for i in 1..10; do
  time Rscript 100_random_numbers.R >> $OUT_DIR/R.txt
done

singularity exec python3 generate_plots.py

wget -P ../Reference ftp://ftp.sanger.ac.uk/pub/gencode/Gencode_human/release_25/gencode.v25.transcripts.fa.gz
gzip -d ../Reference/gencode.v25.transcripts.fa.gz
wget -P ../Reference http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz
gzip -d ../Reference/hg38.fa.gz

art_illumina --rndSeed 1 -i ../Reference/hg38.fa -p -l 150 -c 1000000 -ss HS25 -m 500 -o hg38_1million
# test output location of above. Does it create a file or a folder?
art_illumina --rndSeed 1 -i ../Reference/hg38.fa -p -l 150 -c 10000000 -ss HS25 -m 500 -o hg38_10million
art_illumina --rndSeed 1 -i ../Reference/hg38.fa -p -l 150 -c 100000000 -ss HS25 -m 500 -o hg38_100million

art_illumina --rndSeed 1 -i ../Reference/gencode.v25.transcripts.fa -p -l 150 -c 1000000 -ss HS25 -m 500 -o gencode_1million
# test output location of above. Does it create a file or a folder?
art_illumina --rndSeed 1 -i ../Reference/gencode.v25.transcripts.fa -p -l 150 -c 10000000 -ss HS25 -m 500 -o gencode_10million
art_illumina --rndSeed 1 -i ../Reference/gencode.v25.transcripts.fa -p -l 150 -c 100000000 -ss HS25 -m 500 -o gencode_100million
```
