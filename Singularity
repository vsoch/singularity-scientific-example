Bootstrap: docker
From: ubuntu:trusty

%setup

    cp post.sh $SINGULARITY_ROOTFS

%runscript

    if [ $# -eq 0 ]; then
        echo "\nThe following software is installed in this image:"
        column -t /Software/.info | sort -u --ignore-case        
        echo "\Note that some Anaconda in the list are modules and note executables."
        echo "Example usage: analysis.img [command] [args] [options]"  
    else
        exec "$@"
    fi
        
%post

    chmod u+x /post.sh
    ./post.sh
