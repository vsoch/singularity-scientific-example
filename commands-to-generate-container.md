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
conda install -y --channel kallisto && \
conda clean -y --all && \
cd / && \
rm /environment && \
wget --no-check-certificate https://raw.githubusercontent.com/cjprybol/reproducibility-via-singularity/master/environment && \
wget --no-check-certificate https://gist.githubusercontent.com/cjprybol/222111a4809c57475a3fa47aa1e01db2/raw/05d8729997d61e2f23b8c6d8fe3cc1e3578f2be0/singularity && \
chmod 775 singularity && \
exit
```
