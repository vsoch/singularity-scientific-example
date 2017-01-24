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

# generates a list of checksums for any file that matches *
files=$(find $DATADIR -name \* -print)
for file in "${files[@]}"
do
   : 
      md5sum $file
done
