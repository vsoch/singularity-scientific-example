REFERENCE=../Reference/Homo_sapiens.GRCh38.dna.primary_assembly.fa
OUT_DIR=../Data/RTG
MEM="$1"g

parallel --jobs 1 --xapply rtg RTG_MEM=$MEM map --format fastq --quality-format sanger --template $REFERENCE.sdf --output $OUT_DIR/$3.{1} --left $OUT_DIR/{1}.1.10M.fastq.gz --right $OUT_DIR/{1}.2.10M.fastq.gz --sam-rg {2} --threads $2 ::: HG002 HG003 HG004 :::  "@RG\tID:HG002\tSM:NA24385\tPL:ILLUMINA" "@RG\tID:HG003\tSM:NA24149\tPL:ILLUMINA" "@RG\tID:HG004\tSM:NA24143\tPL:ILLUMINA"
