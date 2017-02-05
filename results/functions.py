# These are supporting functions for the simple python scripts to output
# results and visualizations of them

import pandas
import os
import re
import sys

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

