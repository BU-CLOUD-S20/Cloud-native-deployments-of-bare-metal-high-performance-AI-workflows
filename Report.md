
# Experiment

We run the [BigGAN]() workflow in both [SATORI]() - MIT's super computing cluster with IBM Power PC CPUs, and on OpenShift on the [Mass Open Cloud]() also with  IBM Power PC CPUs.

The instructions to run BigGAN on Satori are [here](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/update-readme/README.md#mit-satori). These instructions are our starting point.

# Conclusions

<h2 align="center"> Text... </h2>

- Efficiency: `measured as the ratio of useful output to total input`
  - text here...
- scalability: 1) It is the ability of a computer application or product (hardware or software) to continue to function well when it (or its context) is changed in size or volume in order to meet a user need. 2) It is the ability not only to function well in the rescaled situation, but to actually take full advantage of it. 
- elasticity: price Elasticity is the responsiveness of demand to change in price
- total training time: total training time of achieving an experiment
- batch computation time: time to finish one batch computation

# The BigGAN workflow

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
