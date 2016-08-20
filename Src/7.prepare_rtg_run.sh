REFERENCE=../Reference/Homo_sapiens.GRCh38.dna.primary_assembly.fa
RTG_DIR=../Data/RTG

rtg format --format fasta --output=$REFERENCE.sdf $REFERENCE


if [ ! -d $RTG_DIR ]; then
	mkdir $RTG_DIR
fi

R1_REGEX=".*/D[0-9]_S[0-9]_L[0-9]+_R1_[0-9]+.fastq.gz"
R2_REGEX=".*/D[0-9]_S[0-9]_L[0-9]+_R2_[0-9]+.fastq.gz"

parallel --xapply find ../Data/{1}_{2}_{3} -type f -regextype posix-egrep -regex $R1_REGEX \> /tmp/{1}.1 \
::: HG002 HG003 HG004 ::: NA24385 NA24149 NA24143 ::: son father mother
parallel --xapply find ../Data/{1}_{2}_{3} -type f -regextype posix-egrep -regex $R2_REGEX \> /tmp/{1}.2 \
::: HG002 HG003 HG004 ::: NA24385 NA24149 NA24143 ::: son father mother

for ID in HG002 HG003 HG004
do
	for num in 1 2
	do
		if [ ! -f $RTG_DIR/$ID.$num.fastq.gz ]
		then
			while read p
			do
				cat $p >> $RTG_DIR/$ID.$num.fastq.gz
			done < /tmp/$ID.$num
		else
			echo "$RTG_DIR/$ID.$num.fastq.gz exists, skipping..."
		fi
	done
done

for ID in HG002 HG003 HG004
do
	for num in 1 2
	do
		gzip -dc $RTG_DIR/$ID.$num.fastq.gz | head -40000000 | gzip > $RTG_DIR/$ID.$num.10M.fastq.gz
	done
done
