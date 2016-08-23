REFERENCE=../Reference/Homo_sapiens.GRCh38.dna.primary_assembly.fa
RTG_DIR=../Data/RTG
MEM="$1"g

rtg RTG_MEM=$MEM family \
	--output $RTG_DIR/"$3".trio \
	--template $REFERENCE.sdf \
	--machine-errors illumina \
	--avr-model illumina-wgs.avr \
	--threads $2 \
	--son NA24385 \
	--father NA24149 \
	--mother NA24143 \
	$RTG_DIR/"$3".HG002/alignments.bam \
	$RTG_DIR/"$3".HG003/alignments.bam \
	$RTG_DIR/"$3".HG004/alignments.bam
