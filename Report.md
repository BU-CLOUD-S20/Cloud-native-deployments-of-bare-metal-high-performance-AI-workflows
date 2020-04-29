
# Experiment

We run the [BigGAN]() workflow in both [SATORI]() - MIT's super computing cluster with IBM Power PC CPUs, and on OpenShift on the [Mass Open Cloud]() also with  IBM Power PC CPUs.

The instructions to run BigGAN on Satori are [here](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/update-readme/README.md#mit-satori). These instructions are our starting point.

index - george

node specs - hao (satori vs openshfit)

# Conclusions

<h2 align="center"> Efficiency </h2>
<h5 align="center"> Measured as the ratio of useful output to total input </h5>
- Text for efficiency here...
  - more text here...

<h2 align="center"> Scalability </h2>
<h5 align="center"> 1) It is the ability of a computer application or product (hardware or software) to continue to function well when it (or its context) is changed in size or volume in order to meet a user need. </h5>
<h5 align="center"> 2) It is the ability not only to function well in the rescaled situation, but to actually take full advantage of it. </h5>

<h2 align="center"> Elasticity </h2>

We selected the BigGAN workflow from a pool of [tutorial examples](https://mit-satori.github.io/tutorial-examples/index.html) offered on the Satori platform.  

We looked into each of the existing examples(workflows) and observed that they all used popular python-written machine learning library such as Tensorflow, PyTorch and Sklearn.  

We further investigate whether these software frameworks allow dynamic resource utilization. In other words, we want to know if these libraries allow the programs to scale-up  resource utilization when the instance(s) it's running in was(were) allocated with more computing resources.

Since the BigGAN workflow is written in PyTorch, we wil focus on discussing the possibility of running/training Pytorch programs in an "elastic manner":

### Elasticity for PyTorch
According to Pytorch documentation [link here](https://pytorch.org/blog/pytorch-adds-new-tools-and-libraries-welcomes-preferred-networks-to-its-community/#tools-for-elastic-training-and-large-scale-computer-vision),  current PyTorch parallelism is achieved by something called **Distributed Data Parallel (DPP)** module, and it has following short-commings:  

1. Parallel jobs cannot start without aquiring all the request nodes(pod/containers).
2. Parallel jobs is not recoverable from node(pod/container) failures.
3. Parallel jobs is not able to incorporate nodes that join later.

Recently the comunity is working on incorporating **elastic training** functionality to PyTorch. Experimental implementation of the functionality can be found at [PyTorch-Elastic](https://github.com/pytorch/elastic).  

However, **PyTorch-Elastic** only supports AWS environment with Amazon Sagemaker and Elastic Kubernetes Service(EKS) and haven't support OpenShift yet.  

After discussion among group members, we figure that given the time and scope of our project, we might not be able to finish adapting **PyTorch-Elastic** to OpenShift environment and re-writing the BigGAN workflow using PyTorch-Elastic APIs by the end of the semester. We will leave it as a future TODO for now.
<!-- <h5 align="center"> shawn </h5> -->

<h2 align="center"> Automation </h2>
<h5 align="center"> jing </h5>

<h2 align="center"> Environment Comparisons </h2>
<h5 align="center"> shubham </h5>

<h2 align="center"> Lessons Learned </h2>
<h5 align="center"> hao </h5>

<h2 align="center"> Environment Issues </h2>
<h5 align="center"> shawn + jing </h5>

### Issue 1: Trouble accessing GPU(s) on MoC

### Issue 2: Trouble pushing to internal image registry on OpenShift

### Issue 3: Pod creation timeout when mounting volume
- talk about problems and solutions attempted

# Running on Satori

We use the instructions to run BigGAN on Satori given [here](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/update-readme/README.md#mit-satori). We use 2 GPUs for training. We measured the CPU usage, GPU usage and memory usage while training. 

## CPU usage

Here we notice that the BigGAN workflow consumes just less than 20 % CPU on average. 

![satori cpu usage](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/master/doc/imgs/sat-cpu.png)

## Memory usage

The memory usage lingers around 8.3%. For the node that we are running on, this is around 95 GB used of 1145 GB available.

![satori memory usage](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/master/doc/imgs/sat-mem.png)


## GPU usage

The GPUs are fully utilized, both GPUs running at almost full capacity. Take note, that this was a shared node, and there might be other users processes running on this GPU node. The workflow can be run in an exlusive node to get the exact usage by only the BigGAN process. However, exclusive nodes are very hard to get scheduled on Satori, in our experience.


![satori gpu usage](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/master/doc/imgs/sat-gpu.png)

## GPU Memory usage

The GPU memory is also pretty well utilized. It is Consistently measured around 80%. 

![satori gpu memory usage](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/master/doc/imgs/sat-gpu-mem.png)


# Running on OpenShift on MOC

We created a docker container that runs the training process of BigGAN. We modified the instructions to run BigGAN on Satori, and use the scripts [here](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/tree/feature-gpubiggan/workflows/BigGAN/gpu).
This test used 1 GPU for training. We measured the CPU usage, GPU usage and memory usage while training. 

## CPU usage

Here we notice that the BigGAN workflow consumes just less around 2 % CPU on average. 

![openshift cpu usage](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/master/doc/imgs/os-cpu.png)


## CPU usage multiplexed with CPU heavy workload

Now, we ran a CPU-heavy workload multiplexed with the BigGAN workflow. We see that more CPU is definitely more utilized.

![openshift cpu-multiplexed usage](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/master/doc/imgs/os-cpu-load.png)



## Memory usage

The memory usage lingers around 15%. For the node that we are running on, this is around 84 GB used of 541 GB available.

![openshift memory usage](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/master/doc/imgs/os-mem.png)

## GPU & GPU memory usage

The GPU is around 40% utilized. This might be because that the GPU is not used by other users. THe GPU memory usage stays between 5-10%.

![openshift gpu usage](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/master/doc/imgs/os-gpu.png)


TODO: Add CPU and GPU specs, for Satori and OpenShift nodes.
