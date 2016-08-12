```bash
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
PATH="/Software/.linuxbrew/bin:$PATH" && \
brew install bash && \
ln -sf /Software/.linuxbrew/bin/bash /bin/bash && \
brew tap homebrew/science && \
brew install art bwa kallisto picard-tools python3 r && \
rm -r $(brew --cache) && \
cd / && \
rm /environment && \
wget --no-check-certificate https://gist.githubusercontent.com/cjprybol/c0adfd9ff64c5cc409a0853e54b67cd8/raw/2af527335fefe99aebf24a267ebd954a28917d01/environment && \
wget --no-check-certificate https://gist.githubusercontent.com/cjprybol/222111a4809c57475a3fa47aa1e01db2/raw/fe69977bcfa163d798007557a3b274e9d90e263f/singularity && \
chmod 775 singularity
```

review size of container with du, and then redo this
