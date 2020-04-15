
# Experiment

We run the [BigGAN]() workflow in both [SATORI]() - MIT's super computing cluster with IBM Power PC CPUs, and on OpenShift on the [Mass Open Cloud]() also with  IBM Power PC CPUs.

The instructions to run BigGAN on Satori are [here](). These instructions are our starting point.

# The BigGAN workflow

# Running on Satori

We use the instructions to run BigGAN on Satori given [here](). We use 2 GPUs for training. We measured the CPU usage, GPU usage and memory usage while training. 

## CPU usage
![satori cpu usage](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/master/doc/imgs/sat-cpu.png)

## Memory usage
![satori memory usage](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/master/doc/imgs/sat-mem.png)


## GPU usage

![satori gpu usage](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/master/doc/imgs/sat-gpu.png)

## Memory usage
![satori gpu memory usage](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/master/doc/imgs/sat-gpu-mem.png)

