<!-- # Singularity: Application containers designed for academic HPC clusters that enable reproducibility in research

## Cameron J. Prybol<sup>1</sup>, Daryl Waggot<sup>2, 3</sup>, Gregory M. Kurtzer<sup>4</sup>, Euan A. Ashley<sup>1, 2, 3</sup>

### <sup>1</sup> Department of Genetics, Stanford University, Stanford, CA, 94305, USA., <sup>2</sup>Department of Medicine, Stanford University, Stanford, CA, 94305, USA., <sup>3</sup>Stanford Center for Inherited Cardiovascular Disease, Stanford University, Stanford, CA, 94305, USA., <sup>4</sup>High Performance Computing Services (HPCS) group, Lawence Berkeley National Laboratory, Berkeley, CA, 94720, USA. -->

**ABSTRACT**

**Motivation**: Efforts are being made across all disciplines of science to increase data-sharing and reproducability. However, researchers are still expected to set up and maintain their own computing environments. Even when the software and version numbers are reported with the code and data, it can be a non-trivial, and time consuming process to configure a sufficiently similar computing environment that will properly execute the code to generate the same results. The problem is exasperated over time as older versions of operating systems and software dependencies are deprecated.

**Results**: Singularity containers enable researchers to run pipelines in isolated computing environments. Designed specifically with academic high-performance computing (HPC) clusters in mind, Singularity overcomes several key security issues of other container platforms that have prevented their adoption outside of enterprise- and cloud-based computing. With no root owned daemon processes or user escalation allowed, Singularity protects the data and files of system administrators and other users on shared clusters, while empowering researchers with more flexibility and freedom to configure computing environments that meet their needs. Users can install software into containers and configure them in the same way they would any other unix- or linux-based operating system. Containers can execute existing source code, often with no modifications required, which allows researchers to utilize it's added benefits of enviroment isolation and reproducability with minimal disturbance to their normal workflows. We provide benchmarks comparing resource usage when running pipelines via containers versus when running directly on the host.

**Availability**: Singularity is available at http://singularity.lbl.gov/. Examples of how to create and utilize containers for research projects are available at https://github.com/cjprybol/reproducibility-via-singularity. The repository associated with the manuscript is available at https://github.com/cjprybol/singularity-manuscript

**Contact**: euan@stanford.edu, gmkurtzer@lbl.gov

## Introduction

Reproducibility is at the core of scientific philosophy, yet is often overlooked in the publication process and difficult to perform in practice. Educational efforts like Software Carpentry and the Mozilla Science Lab have evangelized best-practices used by software developers in order to improve computational literacy and reproducibility across the sciences. Open-source platforms like the Galaxy project and bcbio-nextgen, and commercial services like DNAnexus enable users to run analyses using customizable scripts and rigorously validated pipelines and software. However, these services are focused on common and specific use-cases within the domain of computional biology, which can make them cumbersome for novel analyses and limits their adoption across disciplines. As many universities and research institutions have invested in HPC clusters, and researchers across all domains have experience writing analyses using command line applications and tools that run on linux- and unix-based operating systems, an ideal solution for reproducable research would be one that allowed researchers to use existing infrastructure and skill-sets, and does not require any modificications to their existing code.

Many researchers are already familiar with version-control software like git, mercurial, and svn that allow users to effeciently backup, collaborate on, and distribute the code they use in their projects and analyses. Many journals and funding agencies require data to be made available on archiving services like the Gene Expression Omnibus and European Nucleotide Archive. By combining these existing services with containers like Singularity, end-users who wish to reproduce results need only an internet connection, sufficient resources to store and process the data, and to have the container software installed. This dramatically lowers the energy and skill required for others to review and learn from your work, while also encouraging transparancy and quality of research and increasing the rate of knowledge transfer.

Multiple processes can be run using containers at the same time, making them ammenable to parallelization. Additional benefits include the ability to distribute required software across multiple containers. For example, legacy software that requires outdated operating systems and dependencies can be installed into their own containers, and modern software that have conflicting dependencies can be installed to seperate containers to eliminate library conflicts. All of these containers can be utilized on the same clusters, improving researcher and system administrator productivity by allowing each to spend less time troubleshooting.

# Results

To compare the overhead of running analyses using isolated environments within Singularity containers to running analyses using software installed directly onto the host, we performed several iterations of two benchmarks. The first benchmark quantifies transcript abundances of >68 million 2x75bp reads (Human polyA+ total RNA, GM12878 cell line) from round 1 of the RNA-seq Genome Annotation Assessment Project (http://www.gencodegenes.org/rgasp/data.html) using kallisto [cite]. The second benchmark maps 100 million 2x75bp reads to GRCh38 (ensembl release 85) using bwa [cite]. Each iteration of simulation ran the host and container tests in parallel in an attempt to capture the effects of system load as similarly as we could. Iterations were performed in serial over several days to capture the effects of differing system load throughout the week. For full details including operating systems, cpu architecture, and version numbers of all software used, see **METHODS**

The difference between running the job on a single node vs having it distributed across multiple nodes was far more costly than the difference between running on a single node using host vs. container software.

# Conclusion



# Software versions
