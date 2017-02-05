from functions import (
    apply_command_labels, 
    number_runs 
)

import pandas
import os
import numpy
import pickle
import fnmatch
import json
import re

pwd = os.getcwd()

# Results from gce are in "gce" and hpc in "hpc". Within each
# folder is the cluster (or instance) name, and then within each
# subfolder is the data. For HPC, since we had one running location,
# the stats.log are compiled, and the files logs take the format 
# singularity-files-1.log. For the cloud, each run is a separate folder
# corresponding to a separate instance.

cloud_environments = os.listdir("%s/cloud" %pwd)
hpc_environments = os.listdir("%s/hpc" %pwd)

# Let's save to a data directory
data_dir = "%s/data" %(pwd)
if not os.path.exists(data_dir):
    os.mkdir(data_dir)

df = pandas.DataFrame()

# Parse cloud runs - each instance handles docker/singularity run
for cloud_environment in cloud_environments:
    instances = os.listdir("%s/cloud/%s" %(pwd,cloud_environment))
    for instance in instances:
        instance_logs ='%s/cloud/%s/%s' %(pwd,cloud_environment,instance)
        if os.path.isdir(instance_logs):
            for file_log in os.listdir(instance_logs):
                if fnmatch.fnmatch(file_log, '*files*.log'):
                    software = file_log.split('-')[0]
                    log = pandas.read_csv("%s/%s" %(instance_logs,file_log),sep='  ',engine='python', header=None)
                    log.columns = ['HASH','FILE']
                    log['ENV'] = "cloud-%s" %cloud_environment
                    log['RUN'] = instance
                    log['SOFTWARE'] = software
                    log.index = log['ENV'] + "-" + log['SOFTWARE']
                    df = df.append(log)

# Parse local HPC runs - each cluster handles 3 runs of Singularity
for hpc_environment in hpc_environments:
    cluster_logs = "%s/hpc/%s" %(pwd,hpc_environment)
    file_logs = os.listdir(cluster_logs)
    run = 1
    for file_log in file_logs:
        if fnmatch.fnmatch(file_log, '*files*.log'):
            software = file_log.split('-')[0]
            log = pandas.read_csv("%s/%s" %(cluster_logs,file_log),sep='  ',engine='python', header=None)
            log.columns = ['HASH','FILE']
            log['ENV'] = "hpc-%s" %hpc_environment
            log['RUN'] = run
            run+=1
            log['SOFTWARE'] = software
            log.index = log['ENV'] + "-" + log['SOFTWARE']
            df = df.append(log)

# We need to remove paths up to /data, since they differ between clusters/containers
df['FILE'] = [x.split('data/')[-1] for x in df['FILE']]


##########################################################################################
# QUESTION 1: Are all output/result files present?
##########################################################################################

# Let's do simple bar charts, with analyses sorted by their command, to see timing, etc.
unique_files = df['FILE'].unique().tolist() # 215 unique files

# What files are missing in different runs?
envs =  df.index.unique().tolist()
missing = dict()

for unique_file in unique_files:
    subset = df[df['FILE'] == unique_file]
    found_in = subset.index.unique().tolist()
    for env in envs:
        if env not in found_in:
            if env in missing:
                missing[env].append(unique_file)
            else:
                missing[env] = [unique_file]

# How many for each?
for env,missing_files in missing.items():
    print("%s is missing %s files." %(env,len(missing_files)))

# cloud-gce-singularity is missing 13 files.
# cloud-gce-docker is missing 13 files.
# cloud-aws-docker is missing 13 files.
# cloud-aws-singularity is missing 13 files.

# Ok, confirming that the "missing" files are from one run on sherlock where the download failed,
# and intermediate files were left (that should have been deleted.) These files should not be included
# in final comparison

#['analysis.img',
# 'Fastq/GM12878_2x75_split/GM12878_2x75_rep1.lane1_2.fq',
# 'Fastq/GM12878_2x75_split/GM12878_2x75_rep1.lane1_1.fq',
# 'Fastq/GM12878_2x75_split/GM12878_2x75_rep2.lane1_1.fq',
# 'Fastq/GM12878_2x75_split/GM12878_2x75_rep1.lane3_2.fq',
# 'Fastq/GM12878_2x75_split/GM12878_2x75_rep1.lane2_2.fq',
# 'Fastq/GM12878_2x75_split/GM12878_2x75_rep2.lane1_2.fq',
# 'Fastq/GM12878_2x75_split/GM12878_2x75_rep2.lane2_1.fq',
# 'Fastq/GM12878_2x75_split/GM12878_2x75_rep1.lane2_1.fq',
# 'Fastq/GM12878_2x75_split/GM12878_2x75_rep1.lane3_1.fq',
# 'Fastq/GM12878_2x75_split/GM12878_2x75_rep2.lane2_2.fq',
# 'Fastq/rna_1.fq',
# 'Fastq/rna_2.fq']

# We also don't want to include analysis.img, which is the Singularity container.

df = df[df['FILE'].isin(missing_files)==False]

# We can conclude that all output files (that should be present, given no error in the analysis)
# are present.

##########################################################################################
# QUESTION 2: For each file, are they the same content hash?
##########################################################################################

unique_files = df['FILE'].unique().tolist() # now 202 unique files

# Files that are different across all runs
all_different = []
some_different = []
equivalent = []

for unique_file in unique_files:
    subset = df[df['FILE'] == unique_file]
    unique_hashes = subset['HASH'].unique().tolist()
    if len(unique_hashes) != 1:
        if len(unique_hashes) == len(subset):
            all_different.append(unique_file) 
        else:
            some_different.append(unique_file)
    else:
        equivalent.append(unique_file)


len(equivalent) # 70
len(some_different) # 7
len(all_different) # 125
# sanity check, total is 202

# Here we see that 70 files are equivalent across runs. These tend to be files that are downloaded (great!)
# We should be most concerned about the files that have some different, because this would suggest that they are identical in some places.

# ['RTG/container.HG002/alignments.bam.bai',
# 'RTG/container.trio/snps.vcf.gz.tbi',
# 'RTG/container.HG004/alignments.bam.bai',
# 'RTG/container.HG003/alignments.bam.bai',
# 'Reference/Homo_sapiens.GRCh38.dna.primary_assembly.fa.sdf/done',
# 'Kallisto/rna/abundance.tsv',
# 'Bam/container.bam']

# Looking at all_different, these tend to be the result files. Damn.

# Let's pickle and export some data for Cameron to look at.
df.to_csv("file_outputs.tsv",sep="\t")

result = {'df':df,
          'files_all_different': all_different,
          'files_equivalent': equivalent,
          'some_different': some_different,
          'intermediate_files': missing_files,
          'missing':missing }

pickle.dump(result,open('file_outputs.pkl','wb'))
