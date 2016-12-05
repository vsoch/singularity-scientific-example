# singularity-testing

This repository will provide a complete example of using Singularity to run a reproducible analysis, from the point of data download through result generation. In the process we will do the following:


### Install Singularity

Instructions can be found on the [singularity site](https://singularityware.github.io).

### Get the code

     git clone https://www.github.com/vsoch/singularity-testing
     cd singularity-testing


### Goals for this work

1. We want the different tools to be as modular as possible. This means separating different software into different containers. From development standpoint, a group of experts that maintain a (smaller) software base for which they have expertise is a better strategy than trying to accomodate a larger one.
2. Harness existing containers and solutions. For example, it's unlikely that a researcher would want to develop a new Singularity container for every kind of genetic or new analysis, but it seems reasonable to use the (already existing) library of Docker containers to achieve the same. Developing a Docker container should (and does) correspond directly with having the same versioned software to run in Singularity.
3. Reliable, transparent inputs and outputs. Each software container, regardless of dependencies, operating system, etc., in that it takes and produces data structures and formats in a reliable way, can fit into a workflow that expects or needs those products.
4. Scalable. The analysis should be possible to run optimally on a cluster (HPC).
5. Environment agnostic. It should work equivalently on a local computer, a computer cluster, Google Cloud, AWS, Azure, or other.
6. Customizable. Hopefully the modular nature, and that each container takes input arguments, makes this possible.


### Steps in workflow
1. Download of data
2. Run tests / scripts, each has some input, produces some output, dependencies are maintained
3. Generate visualization of results
4. Generate final manuscript or report


### Development Thinking
- Identify steps we want to do, and create container for each. 
- What kind of additions would need to go to each container bootstrap? E.g., depending on analysis location, we would want to map drives
- Think about how would we download data? Where would we put it?
- Think about inputs and outputs, how do we specify, and make sure that things connect?
- How do we create a dependency structure so that things run when their inputs are available?
- How do different data outputs plug seamlessly into ways to understand them (visualization, final statistical tests, etc.)
- How do we summarize the entire thing (the workflow, and the result, and the metadata/parameters?)


#### 1. Reproducibility
Unfortunately, any download of data, or anything that isn't totally stored with an entire image, is not reproducible because there is potential for it to go away and the entire pipeline breaks. This is likely going to be a balance we have to take into account - we can provide essential data / packages for a particular analysis, and maximize reproducibility of our method despite the unfortunate reality (or assumption) that inputs must be variables.


#### 2. Data Download
There are two kinds of data:

 - standard (e.g., reference) is data that can be distributed with the container, downloaded at runtime, or treated as variable data,
 - variable (e.g., genome) is data that will likely be a variable provided at runtime.

The main question is one about responsibility. Who is responsible for each? My thinking is that standard data (required for analysis) must be provided by the containers. If it is something that is likely to change, the container should check for updated versions. Data that is variable, for example, the inputs, must be provided by the user.

Proposal: For standard data, a container (or part of a pipeline inside) must know that the data is required, and if it's not present where it should be, how to obtain it. For variable data, if a container understands how to do some series of steps given a particular folder structure or input file, entire drives or single files can be mapped at runtime to get the desired function.

### A workflow data structure 
Most workflow data structures (cwl, etc) have something that looks like json, and it's not simple enough. Imagine a Dockerfile, but working one level higher - to obtain data and give it to images. This workflow is also on the level of a single run, meaning one dataset, and it could be run in parallel to accomplish the same for many datasets. For example, I might want something like the following:

```bash
      
    WORKDIR /scratch
    GET file1 file2 file3
    RUN container-setup.img --arg1 file1 --output newfile1
    RUN container-analysis.img --arg1 newfile1 | container-summarize.img --output /scratch/folder
    VIEW --input /scratch/folder
   
```

### The command specification

#### WORKDIR 
is akin to Dockerfile's version - it sets the present working directory, which would be useful for downloading things

#### GET
is a general command to download something. Based on the address (eg, if it's http vs ftp) and based on the extension (.txt vs .tar.gz) the assumption will be to download and extract, although there are cases I can think of where we may want to think of another way to get (and not extract).

#### RUN
should be with a container in mind, assuming it has some understood executable, we give it a container name (Singularity) and the container is either found in the cache, or obtained and cached. The standard RUN will likely take in inputs and outputs and produce 

#### VIEW
The idea of view is to visualize or summarize. There should be a core set of data structures (or other) that the function understands (eg, csv, or brain image) and then it can parse an entire folder and produce a navigatable output (static html thing, or summary report) for the researcher.
