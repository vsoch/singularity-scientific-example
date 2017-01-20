#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Example usage: docker exec vanessa/analysis [command] [args] [options]"  
else
    exec "$@"
fi

