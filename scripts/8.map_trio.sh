if [ $# -eq 0 ]; then
    echo "\nUsage:"
    echo "./8.map_trio.sh [DATADIR]"
    exit
else

DATADIR=$1

if [ ! -d $DATADIR ]; then
    echo "$DATADIR does not exist! Exiting."
    exit
fi

REFERENCE=$DATADIR/Reference/Homo_sapiens.GRCh38.dna.primary_assembly.fa
OUT_DIR=$DATADIR/RTG
MEM=$(echo "scale=2; $(free | grep 'Mem' | perl -p -e 's/^Mem: +(\d+) .+$/$1/') / 1024^2" | bc)
MEM="$MEM"g

parallel --jobs 1 --xapply rtg RTG_MEM=$MEM map --format fastq --quality-format sanger --template $REFERENCE.sdf --output $OUT_DIR/$3.{1} --left $OUT_DIR/{1}.1.10M.fastq.gz --right $OUT_DIR/{1}.2.10M.fastq.gz --sam-rg {2} --threads $2 ::: HG002 HG003 HG004 :::  "@RG\tID:HG002\tSM:NA24385\tPL:ILLUMINA" "@RG\tID:HG003\tSM:NA24149\tPL:ILLUMINA" "@RG\tID:HG004\tSM:NA24143\tPL:ILLUMINA"
