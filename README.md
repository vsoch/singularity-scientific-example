# Singularity Example Scientific Workflow

This repository provides a container and associated pipeline to do comparison of running a Singularity workflow across several cloud providers:

- Google Cloud
- Amazon AWS
- Stanford Sherlock Cluster
- Stanford SCG4 Cluster
- Microsoft Azure

We will ideally look at metrics such as memory and cost, and assess the differences (or lack thereof) in running the analysis in multiple cloud environments.
 
1. Start with a basic analysis, meaning an analysis packaged in a container.
2. Build the container using Singularity Hub
3. Use Singularity Hub and Packer builds (included in this repo) to run and compare. 

The folder [cloud](cloud) contains runscript and other files necessary for running the pipeline on the cloud providers in the list above. The folder [hpc](hpc) contains the equivalent scripts necessary for running on local HPC.


## Moving Data off of the Cloud

You have a few options. If this were a pipeline intended to run in parallel, you would want an endpoint waiting to receive a `POST` with data, or even a simple function to upload to Dropbox. For the purposes of testing, an easy solution is to do one of the following:

 - add the logs to a Github repo
 - transfer the files using scp (or a command, detailed below)


### Google Cloud
Google cloud has easy [transfer of files](https://cloud.google.com/compute/docs/instances/transfer-files) using the `gcloud` command line utility. Eg:

      # Copy from instance to present working directory
      gcloud compute copy-files singularity-scientific:/scratch/logs/* $PWD

### AWS EC2
You can use the traditional tool scp to do this, giving your credential (`.pem`) file for the `-i` argument,

      scp -i ~/.ssh/amazon.pem ubuntu@ec2-52-11-179-238.us-west-2.compute.amazonaws.com:/scratch/logs/* $PWD



### HPC Cluster
For HPC clusters Sherlock and scg4, I used [gftp](https://www.gftp.org/) from my Ubuntu 16.04 machine.



## Local Usage

### Get the code

```bash
     git clone https://www.github.com/vsoch/singularity-testing
     cd singularity-testing
```

Then you can follow the [run.sh](hpc) script in the cloud folder, given that you have sudo access on your endpoint. Running on a cloud provider (with sudo) is equivalent to this.

As an alternative to building the Docker image from the [Dockerfile](Dockerfile) provided, you can also use the one on [docker hub](https://hub.docker.com/r/vanessa/singularity-scientific-example/).


### Goals for this work

1. **Moveable** We have included the entire analysis in Github repo that can be easily cloned and run, given the user provides credentials to the various environments. The container is served by Singularity Hub.
2. **Transparent** The container is transparent in that running it reveals instructions for its use. This should be a minimal requirement for a scientific container. 
3. **Scalable.** The analysis should be possible to run optimally on a cluster (HPC).
4. **Environment Agnostic**. It should work equivalently on a local computer, a computer cluster, Google Cloud, AWS, Azure, or other.
5. **Customizable**. Hopefully the modular nature, and that each container takes input arguments, makes this possible.
