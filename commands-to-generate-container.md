```bash
# generate and enter container
sudo singularity create --size 4000 singularity-manuscript.img && \
wget https://raw.githubusercontent.com/cjprybol/reproducibility-via-singularity/master/ubuntu.def && \
sudo singularity bootstrap singularity-manuscript.img ubuntu.def && \
rm ubuntu.def && \
sudo singularity shell --writable --contain singularity-manuscript.img

# configure container
mkdir /scratch /share /local-scratch && \
apt-get update && \
apt-get install -y build-essential cmake curl wget git python-setuptools ruby && \
apt-get clean && \
mkdir /Software && \
cd /Software && \
git clone https://github.com/Linuxbrew/brew.git /Software/.linuxbrew && \
wget http://repo.continuum.io/archive/Anaconda3-4.1.1-Linux-x86_64.sh && \
bash Anaconda3-4.1.1-Linux-x86_64.sh -b -p /Software/anaconda3 && \
rm Anaconda3-4.1.1-Linux-x86_64.sh && \
PATH="/Software/.linuxbrew/bin:/Software/anaconda3/bin:$PATH" && \
brew install bash parallel util-linux && \
ln -sf /Software/.linuxbrew/bin/bash /bin/bash && \
brew tap homebrew/science && \
brew install art bwa samtools && \
rm -r $(brew --cache) && \
conda update -y conda && \
conda update -y anaconda && \
conda config --add channels bioconda && \
conda install -y --channel bioconda kallisto && \
conda clean -y --all && \
cd /Software && \
wget --no-check-certificate https://github.com/RealTimeGenomics/rtg-core/releases/download/3.6.2/rtg-core-non-commercial-3.6.2-linux-x64.zip && \
unzip rtg-core-non-commercial-3.6.2-linux-x64.zip && \
rm rtg-core-non-commercial-3.6.2-linux-x64.zip && \
ln -s /Software/rtg-core-non-commercial-3.6.2/rtg /usr/local/bin && \
echo "n" | rtg \
cd / && \
rm /environment && \
wget --no-check-certificate https://raw.githubusercontent.com/cjprybol/reproducibility-via-singularity/master/environment && \
wget --no-check-certificate https://gist.githubusercontent.com/cjprybol/222111a4809c57475a3fa47aa1e01db2/raw/cbb393088299a9ee742353438b67c1e2a6bc4b7d/singularity && \
chmod 775 singularity && \
exit
```
