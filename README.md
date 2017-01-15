# Singularity Example Scientific Workflow

This repository provides a container and associated pipeline to do a direct comparison of Singularity vs. Docker, across multiple compute environments:

- Google Cloud
- Amazon AWS
- Stanford Sherlock Cluster
- Stanford SCG4 Cluster
- Microsoft Azure

We will ideally look at metrics such as memory and cost, and aim to show how Singularity (which can be run without sudo priviledges) compares to Docker. The initial plan is generally the following:
 
1. Start with a basic analysis, meaning an analysis packaged in a container.
2. Build the container using Singularity Hub
3. Use Singularity Hub and Packer builds (included in this repo) to run and compare. 


### Install Singularity

Instructions can be found on the [singularity site](https://singularityware.github.io).

### Get the code

```bash
     git clone https://www.github.com/vsoch/singularity-testing
     cd singularity-testing
```

### Goals for this work

1. **Moveable** We have included the entire analysis in Github repo that can be easily cloned and run, given the user provides credentials to the various environments. The container is served by Singularity Hub.
2. **Transparent** The container is transparent in that running it reveals instructions for its use. This should be a minimal requirement for a scientific container. 
3. **Scalable.** The analysis should be possible to run optimally on a cluster (HPC).
4. **Environment Agnostic**. It should work equivalently on a local computer, a computer cluster, Google Cloud, AWS, Azure, or other.
5. **Customizable**. Hopefully the modular nature, and that each container takes input arguments, makes this possible.


### Development Thinking
- Identify steps we want to do, and create container for each. 
- What kind of additions would need to go to each container bootstrap? E.g., depending on analysis location, we would want to map drives
- Think about how would we download data? Where would we put it?
- Think about inputs and outputs, how do we specify, and make sure that things connect?
- How do we create a dependency structure so that things run when their inputs are available?
- How do different data outputs plug seamlessly into ways to understand them (visualization, final statistical tests, etc.)
- How do we summarize the entire thing (the workflow, and the result, and the metadata/parameters?)
