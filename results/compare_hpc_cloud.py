import pandas
import os
import json
import re

pwd = os.getcwd()
gce = pandas.read_csv('%s/gce-cloud/stats.log' %pwd,sep='\t')
sherlock = pandas.read_csv('%s/sherlock-hpc/stats.log' %pwd,sep='\t')
data_dir = "%s/data" %(pwd)
if not os.path.exists(data_dir):
    os.mkdir(data_dir)


def apply_command_labels(data,field=None):
    '''get command labels returns a list of labels and software
    from a list of commands
    :param data: the pandas data frame to add LABEL and SOFTWARE to
    :param field: the field to use for the command. default is COMMAND
    '''
    if field == None:
        field = "COMMAND"

    commands = data[field].tolist()
    labels = []
    softwares = []
    for x in commands:
        software = "singularity"
        label = [m for m in x.split('/') if re.search("[.]sh",m)][0]
        labels.append(label)
        if re.search("docker",x):
            software = "docker"
        softwares.append(software)

    data["LABEL"] = labels
    data['SOFTWARE'] = softwares
    return data

# Give sherlock and hpc common labels
sherlock = apply_command_labels(sherlock)
gce = apply_command_labels(gce)
sherlock['ENV'] = "hpc"
gce['ENV'] = 'cloud'

# Make the index named by environment-software 
# (this will need to be tweaked when we have more than one cloud provider)
gce.index = gce['ENV'] + "-" + gce['SOFTWARE']
sherlock.index = sherlock['ENV'] + "-" + sherlock['SOFTWARE']
data = gce.append(sherlock)

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
