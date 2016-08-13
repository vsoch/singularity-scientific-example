<!-- # Singularity: Application containers designed for academic HPC clusters that enable reproducibility in research

## Cameron J. Prybol<sup>1</sup>, Daryl Waggot<sup>2, 3</sup>, Gregory M. Kurtzer<sup>4</sup>, Euan A. Ashley<sup>1, 2, 3</sup>

### <sup>1</sup> Department of Genetics, Stanford University, Stanford, CA, 94305, USA., <sup>2</sup>Department of Medicine, Stanford University, Stanford, CA, 94305, USA., <sup>3</sup>Stanford Center for Inherited Cardiovascular Disease, Stanford University, Stanford, CA, 94305, USA., <sup>4</sup>High Performance Computing Services (HPCS) group, Lawence Berkeley National Laboratory, Berkeley, CA, 94720, USA. -->

**ABSTRACT**

**Motivation**: Efforts have been made across many disciplines of science to increase the availability of the data and code necessary to reproduce projects. However, researchers are still expected to set up and maintain their own computing environments. Even when the software and version numbers used to generate results are reported, it can be a time consuming and non-trivial process to properly install and configure a sufficiently similar computing environment that will generate the same results. The problem is exasperated over time as older versions of operating systems and software dependencies are deprecated.

**Results**: Containers enable researchers to run pipelines in an entirely isolated namespace from the local machine. As containers are linux-based operating systems packaged into single files, this enables others to replicate your computing enviroment by simply having singularity installed and acquiring a copy of your container file. Unlike other container implementations, Singularity is designed with academic high-performance computing (HPC) clusters in mind. Singularity does not allow root escalation, and all processes are run with the same permission-levels as the user, protecting the integrity of valuable data on the shared computing environments common to many research institutions.

**Availability**: Singularity is available at http://singularity.lbl.gov/. Examples of how to create and utilize containers for research projects are available at https://github.com/cjprybol/reproducibility-via-singularity

**Contact**: euan@stanford.edu, gmkurtzer@lbl.gov

## Introduction

Reproducibility is at the core of scientific philosophy, yet is often very difficult in practice. Educational efforts like Software Carpentry and the Mozilla Science Lab have evangelized best-practices used by software developers in order to improve computational literacy and reproducibility across the sciences. Open-source platforms like the Galaxy project and bcbio-nextgen, and commercial services like DNAnexus enable users to run analyses using customizable scripts and rigorously validated pipelines and software. However, these services are focused on common and specific use-cases within the domain of computional biology, which can make them cumbersome for novel analyses and limits their adoption across disciplines. As many universities and research institutions have invested in HPC clusters, and researchers across all domains have experience writing analyses using command line applications and tools that run on linux- and unix-based operating systems, an ideal solution for reproducable research would be one that allowed researchers to use existing infrastructure and skill-sets, and does not require any modificications to their existing code.

Singularity is an implementation of a container and execution engine that allows users to package and pre-configure computing environments. This enables researchers to develop and distribute computing environments to the clusters on which they work, others with whom they collaborate, and archive and distribute these environments upon publication. Many researchers are already familiar with version-control software like git, mercurial, and svn that allow users to effeciently backup, collaborate on, and distribute the code they use in their projects and analyses. Many journals and funding agencies require data to be made available on archiving services like the Gene Expression Omnibus and European Nucleotide Archive. By combining these existing services with containers like Singularity, end-users who wish to reproduce results need only an internet connection, sufficient resources to store and process the data, and to have the Singularity engine installed, dramatically lowering the energy and skill required for others to review and learn from your work, while also encouraging transparancy and quality of research and increasing the rate of knowledge transfer.

# Results

To compare the overhead of running analyses using isolated environments within Singularity containers to running analyses using software installed directly onto the host, we performed several benchmarks. We tested the startup time required to launch R and Python repls, the resources required to quantify 1 million, 10 million, and 100 million RNA sequencing reads using Kallisto, and the resources to map 1 million, 10 million, and 100 million DNA sequencing reads to Hg38 using bwa. To test a java application, we additionally marked and removed duplicate reads and sorted the bam file output by bwa using picard. The Kallisto and BWA benchmarks were performed using 1 core, 8 cores, and 16 cores. The cluster on which these tests were performed was running RHEL 6 (version) and jobs were submitted and managed using the SLURM job scheduler. The Singularity environment was an ubuntu 14.04 LTS.

# Conclusion

Singularity offers a way for researchers to make their computational projects more reproducible, and does so without requiring any changes to their normal workflow. No modifications to source code or the process of configuring computing environments needs to be changed.

to mobilize the environments they use to perform analyses, and enables them to make their work more reproducable by simply without having to change any of the

# Software versions
R
Python
BWA
Kallisto
Picard
Singularity
Art
container ubuntu
server RHEL
CPUs
slurm
