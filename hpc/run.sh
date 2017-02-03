#!/bin/bash

# This is a very simple running script to execute a single container workflow.
# It will install Singularity, pull a container, and use it to run a series of scripts. 
# It was developed to run on an HPC SLURM cluster, sherlock.stanford.edu at Stanford

#########################################################################################
# Setup and Installation
#########################################################################################

# This is the Github repo with analysis
cd $HOME
git clone https://www.github.com/vsoch/singularity-scientific-example
cd singularity-scientific-example
export BASE=$PWD
export RUNDIR=$BASE/hpc

# Analysis parameters
THREADS=8
MEM=32g

# We have to specify out output directory on scratch
mkdir $SCRATCH/data

# This will be our output/data directory
export WORKDIR=$SCRATCH/data

# Let's also make a logs directory to keep
mkdir $SCRATCH/logs

# Setup of time and recording of other analysis data (see TIME.md)
export TIME_LOG=$SCRATCH/logs/stats.log
export TIME='%C\t%E\t%K\t%I\t%M\t%O\t%P\t%U\t%W\t%X\t%e\t%k\t%p\t%r\t%s\t%t\t%w\n'
echo -e 'COMMAND\tELAPSED_TIME_HMS\tAVERAGE_MEM\tFS_INPUTS\tMAX_RES_SIZE_KB\tFS_OUTPUTS\tPERC_CPU_ALLOCATED\tCPU_SECONDS_USED\tW_TIMES_SWAPPED\tSHARED_TEXT_KB\tELAPSED_TIME_SECONDS\tNUMBER_SIGNALS_DELIVERED\tAVG_UNSHARED_STACK_SIZE\tSOCKET_MSG_RECEIVED\tSOCKET_MSG_SENT\tAVG_RESIDENT_SET_SIZE\tCONTEXT_SWITCHES' > $TIME_LOG

# Download the container to rundir
cd $SCRATCH/data
singularity pull shub://vsoch/singularity-scientific-example
image=$(ls *.img)
mv $image analysis.img
chmod u+x analysis.img

# for scg4 at stanford
#module load singularity/jan2017master

cat << EOF > $RUNDIR/run.job
#!/bin/bash
#SBATCH --partition ibiis,owners
#SBATCH --mem 64G
#SBATCH --time 2-00:00:00
#SBATCH --export ALL
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --mail-user vsochat@stanford.edu
#SBATCH --output=$HOME/singularity-hpc.out
#SBATCH --error=$HOME/singularity-hpc.err
module load singularity
export NUMCORES=$(nproc)
export MEM="$MEM"
export THREADS="$THREADS"
export TIME='%C\t%E\t%K\t%I\t%M\t%O\t%P\t%U\t%W\t%X\t%e\t%k\t%p\t%r\t%s\t%t\t%w\n'
export TIME_LOG=$SCRATCH/logs/stats.log
EOF

echo "singularity exec -B $SCRATCH:/scratch -B $SCRATCH/data:/scratch/data $SCRATCH/data/analysis.img /usr/bin/time -a -o $TIME_LOG bash $BASE/scripts/1.download_data.sh /scratch/data" >> $RUNDIR/run.job
echo "singularity exec -B $SCRATCH:/scratch -B $SCRATCH/data:/scratch/data $SCRATCH/data/analysis.img /usr/bin/time -a -o $TIME_LOG bash $BASE/scripts/2.simulate_reads.sh /scratch/data" >> $RUNDIR/run.job
echo "singularity exec -B $SCRATCH:/scratch -B $SCRATCH/data:/scratch/data $SCRATCH/data/analysis.img /usr/bin/time -a -o $TIME_LOG bash $BASE/scripts/3.generate_transcriptome_index.sh /scratch/data" >> $RUNDIR/run.job
echo "singularity exec -B $SCRATCH:/scratch -B $SCRATCH/data:/scratch/data $SCRATCH/data/analysis.img /usr/bin/time -a -o $TIME_LOG bash $BASE/scripts/4.quantify_transcripts.sh /scratch/data $NUMCORES" >> $RUNDIR/run.job
echo "singularity exec -B $SCRATCH:/scratch -B $SCRATCH/data:/scratch/data $SCRATCH/data/analysis.img /usr/bin/time -a -o $TIME_LOG bash $BASE/scripts/5.bwa_index.sh /scratch/data" >> $RUNDIR/run.job
echo "singularity exec -B $SCRATCH:/scratch -B $SCRATCH/data:/scratch/data $SCRATCH/data/analysis.img /usr/bin/time -a -o $TIME_LOG bash $BASE/scripts/6.bwa_align.sh /scratch/data" >> $RUNDIR/run.job
echo "singularity exec -B $SCRATCH:/scratch -B $SCRATCH/data:/scratch/data $SCRATCH/data/analysis.img /usr/bin/time -a -o $TIME_LOG bash $BASE/scripts/7.prepare_rtg_run.sh /scratch/data" >> $RUNDIR/run.job
echo "singularity exec -B $SCRATCH:/scratch -B $SCRATCH/data:/scratch/data $SCRATCH/data/analysis.img /usr/bin/time -a -o $TIME_LOG bash $BASE/scripts/8.map_trio.sh /scratch/data $MEM $THREADS" >> $RUNDIR/run.job
echo "singularity exec -B $SCRATCH:/scratch -B $SCRATCH/data:/scratch/data $SCRATCH/data/analysis.img /usr/bin/time -a -o $TIME_LOG bash $BASE/scripts/9.family_call_variants.sh /scratch/data $MEM $THREADS" >> $RUNDIR/run.job
echo "bash $BASE/scripts/summarize_results.sh $SCRATCH/data > $SCRATCH/logs/singularity-files.log" >> $RUNDIR/run.job
echo "sed -i '/^$/d' $SCRATCH/logs/singularity-files.log" >> $RUNDIR/run.job
echo "sed -i '/^$/d' $SCRATCH/logs/stats.log" >> $RUNDIR/run.job

qsub $RUNDIR/run.job
