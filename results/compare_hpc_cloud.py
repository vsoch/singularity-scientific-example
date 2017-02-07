from functions import (
    apply_command_labels, 
    number_runs 
)

import pandas
import os
import numpy
import json
import re

pwd = os.getcwd()

# Results from gce are in "gce" and hpc in "hpc". Within each
# folder is the cluster (or instance) name, and then within each
# subfolder is the data. For HPC, since we had one running location,
# the stats.log are compiled, and the files logs take the format 
# singularity-files-1.log. For the cloud, each run is a separate folder
# corresponding to a separate instance.

# This script will simply look at output consistency across different
# environments and runs, arguably what the scientist cares about.

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
        instance_log = '%s/cloud/%s/%s/stats.log' %(pwd,cloud_environment,instance)
        if os.path.exists(instance_log):
            log = pandas.read_csv(instance_log,sep='\t')
            tmp = apply_command_labels(log)
            tmp['ENV'] = "cloud-%s" %cloud_environment
            tmp['RUN'] = instance
            tmp.index = tmp['ENV'] + "-" + tmp['SOFTWARE']
            df = df.append(tmp)


# Parse local HPC runs - each cluster handles 3 runs of Singularity
# Parse cloud runs - each instance handles docker/singularity run
for hpc_environment in hpc_environments:
    runs_log = '%s/hpc/%s/stats.log' %(pwd,hpc_environment)
    if os.path.exists(runs_log):
        log = pandas.read_csv(runs_log,sep='\t')
        tmp = apply_command_labels(log)
        tmp = number_runs(tmp)
        tmp['ENV'] = "hpc-%s" %hpc_environment
        run_strings = [str(int(x)) for x in tmp['RUN'].tolist()]
        tmp.index = tmp['ENV'] + "-" + tmp['SOFTWARE']
        df = df.append(tmp)

# Let's do simple bar charts, with analyses sorted by their command, to see timing, etc.

# gce/sherlock
envs =  df.index.unique().tolist()
#envs = df['ENV'].unique().tolist()
xlabels = df['LABEL'].unique().tolist()

# Don't use variables that are zero across
dont_includes =["NUMBER_SIGNALS_DELIVERED","FS_INPUTS","AVERAGE_MEM","SHARED_TEXT_KB","SOCKET_MSG_RECEIVED",
                "SOCKET_MSG_SENT","W_TIMES_SWAPPED","AVG_RESIDENT_SET_SIZE","AVG_UNSHARED_STACK_SIZE",
                "ELAPSED_TIME_HMS"]
dont_includes = dont_includes + ['LABEL','COMMAND','SOFTWARE','ENV','RUN']

# A function to convert string H:M:S to minutes
def hms_to_minutes(time_string):
    # If there is a ., then we just have hours minutes
    time_string = time_string.split('.')[0]
    parts = time_string.split(':')
    if len(parts) == 2:
        m,s = parts
        h = 0
    else:
        h,m,s = parts
    h = int(h) * 60
    m = int(m)
    s = int(s) / 60.0
    return h+m+s

# A function to convert percent % to numerical
def perc_to_number(input_string):
    return [int(x.strip('%'))/100 for x in input_string]
    
df = df.rename(index=str, columns={"ELAPSED_TIME_SECONDS": "ELAPSED_TIME_SEC"})
variables = [x for x in df.columns if x not in dont_includes]
import plotly.graph_objs as go

# Produce data for option 1 - showing all scripts (as different colored bars) for each metric

for var in variables:
    traces = []
    # This will be a list of traces, one per command (xlabel)
    for xlabel in xlabels:
        ydata_group = []
        error_y_group = []
        envs_group = []
        for e in envs:
            subset = df[df.index == e]
            ydata = subset[var][subset['LABEL'] == xlabel].tolist()
            # Specific parsing for time (HMS)
            if var == "ELAPSED_TIME_HMS":
                ydata = [hms_to_minutes(t) for t in ydata]
            if var == "PERC_CPU_ALLOCATED":
                ydata = perc_to_number(ydata)
            if sum(ydata) > 0:
                ydata_group.append(numpy.mean(ydata))
                error_y_group.append(numpy.std(ydata, axis=0))
                envs_group.append(e)                
        xlabel = xlabel.replace(' ','')
        trace = go.Bar(x=envs_group,
                       y=ydata_group,
                       name=xlabel,
                       error_y=dict(type='data',
                                    array=error_y_group,
                                    visible=True))
        traces.append(trace)

        # Save to file
        if len(envs_group) > 0:
            with open('%s/%s.json' %(data_dir,var),'w') as filey:
                json.dump(traces,filey)

# Produce data for option 2 - showing all metrics (with normalized Y) for each script

envs = df['ENV'].unique()

for var in variables: # metric

    for xlabel in xlabels: # script

        # Each trace is one variable and script for each environment 
        traces = []

        # This will be a list of traces, one per command (xlabel)
        subset = df[df['LABEL'] == xlabel]
        softwares = subset.SOFTWARE.unique().tolist()

        for software in softwares:
            ydata_group = []
            error_y_group = []
            for e in envs:
                envset = subset[subset.ENV == e]
                ydata = envset[var][envset['SOFTWARE'] == software].tolist()
                # Specific parsing for time (HMS)
                if var == "ELAPSED_TIME_HMS":
                    ydata = [hms_to_minutes(t) for t in ydata]
                if var == "PERC_CPU_ALLOCATED":
                    ydata = perc_to_number(ydata)
                if sum(ydata) > 0:
                    ydata_group.append(numpy.mean(ydata))
                    error_y_group.append(numpy.std(ydata, axis=0))                
                else:
                    ydata_group.append(0)
                    error_y_group.append(0)                 

            trace = go.Bar(x=envs.tolist(),
                           y=ydata_group,
                           name=software,
                           error_y=dict(type='data',
                                        array=error_y_group,
                                        visible=True))
            traces.append(trace)

        # Save to file
        xlabel = xlabel.replace(' ','')
        with open('%s/%s_%s.json' %(data_dir,var,xlabel),'w') as filey:
            json.dump(traces,filey)


# Finally, let's print an index.html file from the template!
with open('template.html','r') as filey:
    template = filey.read()


# These are info / about blocks to add to each, depending on the variable
varlookup = {'AVERAGE_MEM':'Maximum resident set size, or memory (RAM in KB)',
             'CONTEXT_SWITCHES':'Number of voluntary context-switches (e.g., while waiting for an I/O)',
             'CPU_SECONDS_USED':'Total number of CPU seconds used directly (in user mode, seconds)',
             'MAX_RES_SIZE_KB':"Maximum resident set size of the process (in Kilobytes)",
             'ELAPSED_TIME_SEC':'Elapsed real (wall clock) time used by the process (seconds)',
             'FS_OUTPUTS':'number of file system outputs',
             'FS_INPUTS':'number of file system inputs',
             'PERC_CPU_ALLOCATED':'Percentage of CPU allocated for'}

scriptlookup = {'1.download_data.sh':'downloading reference genomes and other required data',
                '2.simulate_reads.sh':'simulating short (Illumina) reads from the human reference genome (build 38 for step 6)',
                '3.generate_transcriptome_index.sh':'preparing a lookup of the reference human transcriptome for pseudo-mapping RNA transcripts (used in step 4.)',
                '4.quantify_transcripts.sh':'quantifying transcript abundances in an RNA seq dataset from human cell line GM12878',
                '5.bwa_index.sh':'preparing a lookup of the reference human genome for mapping simulated reads, used in step 6.',
                '6.bwa_align.sh':'mapping the simulated reads from step 2 to the human reference genome',
                '7.prepare_rtg_run.sh':'preparing a lookup of the reference human genome for mapping the reads from the Ashkenazi Jew trio provided by Genome In a Bottle',
                '8.map_trio.sh':'mapping the reads from the trio to the human reference genome, build 38',
                '9.family_call_variants.sh':'locating loci in the genomes of the trio that differ from the reference genome, in a pedigree-aware manner'}

nodata = '<div class="heatmap-blank-metric"></div>'

# This is a header row of script names
data= ''
for xlabel in xlabels:
    xlabel_truncated = "%s..." %xlabel[0:20]
    data = '''%s\n<div class="heatmap-blank-metric">%s</div>'''%(data,xlabel_truncated)

for v in range(len(variables)): # metric
    var = variables[v]

    for xlabel in xlabels: # script
        xlabel = xlabel.replace(' ','')
        data_path = 'data/%s_%s.json' %(var,xlabel)
        title = "%s for %s" %(varlookup[var],scriptlookup[xlabel])
        if os.path.exists(data_path): # must be in results as pwd
            newpath = '''<div class="heatmap-metric heatmap-level-%s" data-metric="%s" data-step="%s" data-title="%s">
                             <div class="heatmap-actual">%s</div>
                         </div>''' %(v+1,var,xlabel,title,var)
        else:
            newpath = nodata
        data = "%s\n%s" %(data,newpath)

template = template.replace('[[DATA]]',data)
with open('index.html','w') as filey:
    filey.writelines(template)


# Save final data file for (non empty) metrics
keepers = ['COMMAND','LABEL', 'SOFTWARE', 'ENV','RUN'] + variables
df[keepers].to_csv('compiled_result.tsv',sep='\t')
