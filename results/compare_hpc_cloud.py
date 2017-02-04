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



# Supporting functions

def apply_command_labels(data,field=None, identifier=None):
    '''get command labels returns a list of labels and software
    from a list of commands. The docker containers, by default, will
    have the path bash /code in them. This works for this example, and
    should be checked if re-used in the rare case that the user cluster
    also has this path
    :param data: the pandas data frame to add LABEL and SOFTWARE to
    :param field: the field to use for the command. default is COMMAND
    :param identifier: should be a term or regular expression that indicates
    the container is docker (and not singularity)
    '''
    if field == None:
        field = "COMMAND"
    if identifier == None:
        identifier = '/code/'

    commands = data[field].tolist()
    labels = []
    softwares = []
    for x in commands:
        software = "singularity"
        label = [m for m in x.split('/') if re.search("[.]sh",m)][0]
        labels.append(label)
        if re.search(identifier,x):
            software = "docker"
        softwares.append(software)

    data["LABEL"] = labels
    data['SOFTWARE'] = softwares
    return data


def number_runs(data,unique_label=None):
    '''number runs will determine the run number for a sorted (by time) 
    data frame based on calculating the number of runs from the unique_label
    For example, a data frame with 27
    '''
    if unique_label == None:
        unique_label = "LABEL"

    rows = len(data.index)
    jobs = len(data[unique_label].unique())
    number_jobs = rows / jobs # just sanity check
    print("Data frame has %s runs." %(number_jobs))
    start = 0
    for i in range(int(number_jobs)):
        end = start + jobs
        for idx in range(start,end):
            data.loc[idx,"RUN"] = int(i+1)
        start = end
    return data

# Running Main Section

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
dont_includes =["NUMBER_SIGNALS_DELIVERED","SHARED_TEXT_KB","SOCKET_MSG_RECEIVED","SOCKET_MSG_SENT",
                "W_TIMES_SWAPPED","AVG_RESIDENT_SET_SIZE","AVG_UNSHARED_STACK_SIZE"]
dont_includes = dont_includes + ['LABEL','COMMAND','SOFTWARE','ENV','RUN']
variables = [x for x in df.columns if x not in dont_includes]

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
    
import plotly.graph_objs as go

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


# Save final data file for (non empty) metrics
keepers = ['COMMAND','LABEL', 'SOFTWARE', 'ENV','RUN'] + variables
df[keepers].to_csv('compiled_result.tsv',sep='\t')
