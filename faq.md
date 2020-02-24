# FAQ

1. What is the workload manager used on Satori?

    Computational work on Satori is performed within jobs managed by a workload manager (IBM LSF). More details on how to run AI jobs on Satori can be found [here](https://mit-satori.github.io/satori-workload-manager.html).

2. Can you just pull a Docker container on Satori and run it?

    Theoretically, you can if the container is made for the Power 9 architecture. Satori runs on IBM Power 9 PCs (which have their own instruction set, which is not x86). 

3. Can you create Singularity images on Satori?

    Currently, it is not trivial to do so. To create Singularity images, you need sudo access. Satori runs IBM Power9 PCs, and most of us do not have sudo access on Power 9 PCs.

4. What are some examples of running ML batch jobs on Satori?

    Some examples of running Machine Leaning LSF jobs can be found [here](https://mit-satori.github.io/lsf-templates/satori-lsf-ml-examples.html#example-machine-learning-lsf-jobs). 

References: [MIT Satori Documentation](https://mit-satori.github.io/index.html)