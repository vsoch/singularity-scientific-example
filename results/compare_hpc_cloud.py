import pandas
import os
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


# Running Main Section

cloud_environments = os.listdir("%s/cloud" %pwd)

# Let's save to a data directory
data_dir = "%s/data" %(pwd)
if not os.path.exists(data_dir):
    os.mkdir(data_dir)

df = pandas.DataFrame()

for cloud_environment in cloud_environments:
    instances = os.listdir("%s/cloud/%s" %(pwd,cloud_environment))
    for instance in instances:
        instance_log = '%s/cloud/%s/%s/stats.log' %(pwd,cloud_environment,instance)
        if os.path.exists(instance_log):
            log = pandas.read_csv(instance_log,sep='\t')
            tmp = apply_command_labels(log)
            tmp['ENV'] = cloud_environment
            tmp['RUN'] = instance
            tmp.index = tmp['ENV'] + "-" + tmp['SOFTWARE'] + '-' + tmp['RUN']
            df = df.append(tmp)


# Let's do simple bar charts, with analyses sorted by their command, to see timing, etc.

# gce/sherlock
envs =  data.index.unique().tolist()
xlabels = data['LABEL'].unique().tolist()

# For each label, generate a set of bars for each of the variables
dont_includes = ['LABEL','COMMAND','SOFTWARE','ENV']
variables = [x for x in data.columns if x not in dont_includes]

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


for var in variables:
    # This will be a list of traces, one per command (xlabel)
    traces = []
    has_data = False
    for xlabel in xlabels:
        ydata = data[var][data['LABEL'] == xlabel].tolist()
        xlabel = xlabel.replace(' ','')
        # Specific parsing for time (HMS)
        if var == "ELAPSED_TIME_HMS":
            ydata = [hms_to_minutes(t) for t in ydata]
        if len(ydata) > 0:
            has_data = True
            trace = go.Bar(x=envs,
                           y=ydata,
                           name=xlabel)
            traces.append(trace)

    if has_data == True:
        # Save to file
        with open('%s/%s.json' %(data_dir,var),'w') as filey:
            json.dump(traces,filey)

# Save final data file for (non empty) metrics
keepers = ['COMMAND', 'FS_INPUTS', 'FS_OUTPUTS', 'PERC_CPU_ALLOCATED', 'CPU_SECONDS_USED',
           'ELAPSED_TIME_SECONDS', 'CONTEXT_SWITCHES', 'LABEL', 'SOFTWARE', 'ENV']
data[keepers].to_csv('compiled_result.tsv',sep='\t')
