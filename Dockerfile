FROM ubuntu:trusty
MAINTAINER vsochat@stanford.edu

RUN locale-gen "en_US.UTF-8"
RUN dpkg-reconfigure locales
RUN export LANGUAGE="en_US.UTF-8"
RUN echo 'LANGUAGE="en_US.UTF-8"' >> /etc/default/locale
RUN echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale
RUN mkdir /share /local-scratch /Software
RUN mkdir -p /scratch/data
RUN chmod -R 777 /scratch
RUN chmod 777 /tmp
RUN chmod +t /tmp
RUN chmod 777 /Software
RUN apt-get update
RUN apt-get install -y apt-transport-https build-essential cmake curl libsm6 libxrender1 libfontconfig1 wget vim git unzip python-setuptools ruby bc
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 51716619E084DAB9
RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y r-base-dev gdebi-core
RUN apt-get clean

# Install homebrew science, can't use root
RUN useradd -m singularity
WORKDIR /Software
RUN su -c 'git clone https://github.com/Linuxbrew/brew.git' singularity
RUN su -c '/Software/brew/bin/brew install bsdmainutils parallel util-linux' singularity
RUN su -c '/Software/brew/bin/brew tap homebrew/science' singularity
RUN su -c '/Software/brew/bin/brew install art bwa samtools' singularity
RUN su -c 'rm -r $(/Software/brew/bin/brew --cache)' singularity
RUN su -c 'wget http://repo.continuum.io/archive/Anaconda3-4.1.1-Linux-x86_64.sh' singularity

RUN bash Anaconda3-4.1.1-Linux-x86_64.sh -b -p /Software/anaconda3
RUN rm Anaconda3-4.1.1-Linux-x86_64.sh
RUN /Software/anaconda3/bin/conda update -y conda
RUN /Software/anaconda3/bin/conda update -y anaconda
RUN /Software/anaconda3/bin/conda config --add channels bioconda
RUN /Software/anaconda3/bin/conda install -y --channel bioconda kallisto
RUN /Software/anaconda3/bin/conda clean -y --all
RUN wget --no-check-certificate https://github.com/RealTimeGenomics/rtg-core/releases/download/3.6.2/rtg-core-non-commercial-3.6.2-linux-x64.zip
RUN unzip rtg-core-non-commercial-3.6.2-linux-x64.zip
RUN echo "n" | /Software/rtg-core-non-commercial-3.6.2/rtg --version

RUN mkdir /code
ADD . /code
COPY ./docker-start.sh /code/docker-start.sh
RUN chmod u+x /code/docker-start.sh
WORKDIR /code

# Environmental variables
ENV WORKDIR /scratch/data
ENV RUNDIR /code/cloud
ENV BASE /code

ENV TIME_LOG $RUNDIR/logs/stats.log
ENV TIME '%C\t%E\t%I\t%K\t%M\t%O\t%P\t%U\t%W\t%X\t%e\t%k\t%p\t%r\t%s\t%t\t%w\n'

CMD "/code/docker-start.sh"
