sudo singularity create --size 8000 singularity-manuscript.img
wget https://raw.githubusercontent.com/cjprybol/reproducibility-via-singularity/master/ubuntu.def
sudo singularity bootstrap singularity-manuscript.img ubuntu.def
sudo singularity shell --writable --contain singularity-manuscript.img
mkdir /scratch /share /local-scratch && \
apt-get update && \
apt-get install -y build-essential cmake curl wget git python-setuptools ruby && \
apt-get clean && \
mkdir /Software && \
cd /Software && \
git clone https://github.com/Linuxbrew/brew.git /Software/.linuxbrew && \
wget http://repo.continuum.io/archive/Anaconda3-4.1.0-Linux-x86_64.sh && \
bash Anaconda3-4.1.0-Linux-x86_64.sh -b -p /Software/anaconda3 && \
rm Anaconda3-4.1.0-Linux-x86_64.sh && \
PATH="/Software/.linuxbrew/bin:/Software/anaconda3/bin:$PATH" && \
brew install bash && \
ln -sf /Software/.linuxbrew/bin/bash /bin/bash && \
brew tap homebrew/science && \
brew install art bwa picard-tools r && \
rm -r $(brew --cache) && \
conda update -y conda && \
conda update -y anaconda && \
conda config --add channels bioconda && \
conda install -y --channel bioconda kallisto && \
conda clean -y --all && \
cd / && \
rm /environment && \
wget --no-check-certificate https://raw.githubusercontent.com/cjprybol/reproducibility-via-singularity/master/environment && \
wget --no-check-certificate https://raw.githubusercontent.com/cjprybol/singularity-manuscript/master/singularity && \
chmod 775 singularity













# review size of container with du, and then redo this
