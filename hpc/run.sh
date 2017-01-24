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

# We have to specify out output directory on scratch
mkdir $SCRATCH/data

# This will be our output/data directory
export WORKDIR=$SCRATCH/data

# Let's also make a logs directory to keep
mkdir $RUNDIR/logs

# Setup of time and recording of other analysis data (see TIME.md)
export TIME_LOG=$RUNDIR/logs/stats.log
export TIME='%C\t%E\t%I\t%K\t%M\t%O\t%P\t%U\t%W\t%X\t%e\t%k\t%p\t%r\t%s\t%t\t%w\n'
echo -e 'COMMAND\tELAPSED_TIME_HMS\tFS_INPUTS\tAVG_MEMORY_KB\tMAX_RES_SIZE_KB\tFS_OUTPUTS\tPERC_CPU_ALLOCATED\tCPU_SECONDS_USED\tW_TIMES_SWAPPED\tSHARED_TEXT_KB\tELAPSED_TIME_SECONDS\tNUMBER_SIGNALS_DELIVERED\tAVG_UNSHARED_STACK_SIZE\tSOCKET_MSG_RECEIVED\tSOCKET_MSG_SENT\tAVG_RESIDENT_SET_SIZE\tCONTEXT_SWITCHES' > $TIME_LOG

# Download the container to rundir
cd $SCRATCH/data
singularity pull shub://vsoch/singularity-scientific-example
image=$(ls *.img)
mv $image analysis.img
chmod u+x analysis.img

# Write jobfile. This could be separated into different runs, but we will do it at once.

cat << EOF > $RUNDIR/run.job
#!/bin/bash
#SBATCH --partition ibiis,owners
#SBATCH --mem 64G
#SBATCH --time 2-00:00:00
#SBATCH --export ALL
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --mail-user vsochat@stanford.edu
#SBATCH --output singularity-hpc.out
#SBATCH --error singularity-hpc.err
module load singularity
export NUMCORES=$(nproc)
export TIME='%C\t%E\t%I\t%K\t%M\t%O\t%P\t%U\t%W\t%X\t%e\t%k\t%p\t%r\t%s\t%t\t%w\n'
EOF

echo "/usr/bin/time -a -o $TIME_LOG singularity exec -B $SCRATCH/data:/scratch/data $SCRATCH/data/analysis.img bash $BASE/scripts/1.download_data.sh $SCRATCH/data" >> $RUNDIR/run.job
echo "/usr/bin/time -a -o $TIME_LOG singularity exec -B $SCRATCH/data:/scratch/data $SCRATCH/data/analysis.img bash $BASE/scripts/2.simulate_reads.sh $SCRATCH/data" >> $RUNDIR/run.job
echo "/usr/bin/time -a -o $TIME_LOG singularity exec -B $SCRATCH/data:/scratch/data $SCRATCH/data/analysis.img bash $BASE/scripts/3.generate_transcriptome_index.sh $SCRATCH/data" >> $RUNDIR/run.job
echo "/usr/bin/time -a -o $TIME_LOG singularity exec -B $SCRATCH/data:/scratch/data $SCRATCH/data/analysis.img bash $BASE/scripts/4.quantify_transcripts.sh $SCRATCH/data" >> $RUNDIR/run.job
echo "/usr/bin/time -a -o $TIME_LOG singularity exec -B $SCRATCH/data:/scratch/data $SCRATCH/data/analysis.img bash $BASE/scripts/5.bwa_index.sh $SCRATCH/data" >> $RUNDIR/run.job
echo "/usr/bin/time -a -o $TIME_LOG singularity exec -B $SCRATCH/data:/scratch/data $SCRATCH/data/analysis.img bash $BASE/scripts/6.bwa_align.sh $SCRATCH/data" >> $RUNDIR/run.job
echo "/usr/bin/time -a -o $TIME_LOG singularity exec -B $SCRATCH/data:/scratch/data $SCRATCH/data/analysis.img bash $BASE/scripts/7.prepare_rtg_run.sh $SCRATCH/data" >> $RUNDIR/run.job
echo "/usr/bin/time -a -o $TIME_LOG singularity exec -B $SCRATCH/data:/scratch/data $SCRATCH/data/analysis.img bash $BASE/scripts/8.map_trio.sh $SCRATCH/data $MEM" >> $RUNDIR/run.job
echo "/usr/bin/time -a -o $TIME_LOG singularity exec -B $SCRATCH/data:/scratch/data $SCRATCH/data/analysis.img bash $BASE/scripts/9.family_call_variants.sh $SCRATCH/data $MEM" >> $RUNDIR/run.job
echo "bash $RUNDIR/scripts/summarize_results.sh $SCRATCH/data > $RUNDIR/hpc/logs/singularity-files.log" >> $RUNDIR/run.job

qsub $RUNDIR/run.job
