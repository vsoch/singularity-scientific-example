#!/bin/sh

# summarize results will simply take the md5 hashsum for all files in a directory, and 
# print to the screen

if [ $# -eq 0 ]; then
    echo "\nUsage:"
    echo "./summarize_results.sh [DATADIR]"
    exit
fi

DATADIR=$1

if [ ! -d $DATADIR ]; then
    echo "$DATADIR does not exist! Exiting."
    exit
fi

md5sum $DATADIR/*   # generates a list of checksums for any file that matches *
#md5sum -c checklist.chk   # runs through the list to check them
