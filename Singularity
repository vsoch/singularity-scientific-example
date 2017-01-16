# Note this is provided solely for reference purposes
# current tests are not run using this version
# This works to autobuild container with Singularity version >= 2.2
# Tests were run using container built and executed with 2.1.2 using commands in
# commands-to-generate-container.md

Bootstrap: docker
From: ubuntu:trusty

%runscript

    if [ $# -eq 0 ]; then
        echo "\nThe following software is installed in this image:"
        column -t /Software/.info | sort -u --ignore-case        
        echo "\nExample usage: analysis.img [command] [args] [options]"  
    else
        exec "$@"
    fi
        

%post
    sed -i 's/$/ universe/' /etc/apt/sources.list
    locale-gen "en_US.UTF-8"
    dpkg-reconfigure locales
    export LANGUAGE="en_US.UTF-8"
    echo 'LANGUAGE="en_US.UTF-8"' >> /etc/default/locale
    echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale
    apt-get update
    apt-get install -y wget unzip
    mkdir /scratch /share /local-scratch /Software
    chmod 777 /Software
    apt-get install -y apt-transport-https build-essential cmake curl libsm6 libxrender1 libfontconfig1 wget vim git unzip python-setuptools ruby
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 51716619E084DAB9
    echo "deb https://cloud.r-project.org/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list
    apt-get update
    apt-get install -y r-base-dev gdebi-core
    apt-get clean

    # Install packages with homebrew, not possible with root
    useradd -m singularity
    cd Software
    su -c 'git clone https://github.com/Linuxbrew/brew.git' singularity
    su -c '/Software/brew/bin/brew install bsdmainutils parallel util-linux' singularity
    su -c '/Software/brew/bin/brew tap homebrew/science' singularity
    su -c '/Software/brew/bin/brew install art bwa samtools' singularity
    su -c 'rm -r $(/Software/brew/bin/brew --cache)' singularity
    
    # Install anaconda
    wget http://repo.continuum.io/archive/Anaconda3-4.1.1-Linux-x86_64.sh
    bash Anaconda3-4.1.1-Linux-x86_64.sh -b -p /Software/anaconda3
    rm Anaconda3-4.1.1-Linux-x86_64.sh
    /Software/anaconda3/bin/conda update -y conda
    /Software/anaconda3/bin/conda update -y anaconda
    /Software/anaconda3/bin/conda config --add channels bioconda
    /Software/anaconda3/bin/conda install -y --channel bioconda kallisto
    /Software/anaconda3/bin/conda clean -y --all
    wget --no-check-certificate https://github.com/RealTimeGenomics/rtg-core/releases/download/3.6.2/rtg-core-non-commercial-3.6.2-linux-x64.zip
    unzip rtg-core-non-commercial-3.6.2-linux-x64.zip
    echo "n" | /Software/rtg-core-non-commercial-3.6.2/rtg --version

    # Write a file for the user to read about what is installed
    /Software/anaconda3/bin/conda list | tail -n+3 | awk '{print $1, $2, "Anaconda"}' >> /Software/.info        
    find /Software/brew/Cellar -maxdepth 2 -print | sed 's|/Software/brew/Cellar||g' | sed 's|^/||' | grep "/" | sed 's|/|\t|' | sort | awk '{print $1, $2, "Homebrew"}'>> /Software/.info
    /Software/rtg-core-non-commercial-3.6.2/rtg version | head -1 | awk '{print $2, $5, "User_Install"}' >> /Software/.info

    # Make sure software paths added to the environment
    echo '\nexport PATH=$PATH:/Software/anaconda3/bin' >> /environment
    echo 'export PATH=$PATH:/Software/rtg-core-non-commercial-3.6.2' >> /environment
    echo 'export PATH=$PATH:/Software/brew/bin' >> /environment
