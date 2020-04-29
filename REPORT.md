
<h2 align="center"> Bare Metal High Performance AI Final Report </h2>

In this project, we take an AI workfow - [BigGAN](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/update-readme/README.md#mit-satori) in our case - that is operational in MIT's HPC [Satori](https://mit-satori.github.io/) (modded with IBM Power PC CPUs, NVIDIA V100 GPUs, etc.) and convert it to a running workflow on OpenShift ([Mass Open Cloud](https://massopen.cloud/)) to measure similarities and to delineate the process of moving an application from a bare metal environment to a cloud native platform.

The instructions to run BigGAN on Satori are [here](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/update-readme/README.md#mit-satori). These instructions are our starting point.

***
# Index
1. [Conclusions](#Conclusions)
2. [Running On Satori](#Running-on-Satori)
3. [Running on Mass Open Cloud](#Running-on-OpenShift-on-MOC)

|                  | MIT Satori    | MOC  |
| :-------------:  |:-------------:| -----:|
| GPU Architecture | TESLA V100 32GB | $1600 |
| CPU Architecture | IBM Power9       |   $12 |
| zebra stripes | are neat      |    $1 |

# 1. Conclusions

### 1. Efficiency 
`Measured as the ratio of useful output to total input (measured in CPU/GPU cycles here)` 
- Text for efficiency here...
  - more text here...

### 2. Scalability 
`The ability of the cloud platform to function well when it's changed in size or volume in order to meet a user need (i.e. to rescale).` 

### 3. Elasticity 
 shawn 

### 4. Automation 
Compared with Satori, OpenShift does have more advantages on tasks automation. We depolyed the AI workflow on OpenShift by using `DeploymentConfig`, `BuildConfig`, `Dockerfile`. The codes of AI workflow are on the Github repository, and we can set the triggers inside `BuildConfig` which makes `BuildConfig` be triggered after we pushing new changes to the Github repository, which can build a new image based on our new codes **automatically**, and after the build finished, it will trigger `DeploymentConfig` to start deploy a container from the image built just now **automatically**. The only thing for researchers need to do is just push the new codes, and the AI workflows can be deployed **automatically** and get the result, without requesting node resources or submitting bash jobs.

![](https://www.lucidchart.com/publicSegments/view/35091b47-7861-4f5d-a2e9-5e4afddfaaaf/image.png)

### 5. Environment Comparisons </h2>
 shubham 

### 6. Lessons Learned </h2>
 hao 

### 7. Environment Issues
 shawn + jing 
- talk about problems and solutions attempted

- Cannot get Nvidia cards in OpenShift container
  * **Solution**: expose necessary environment variables for Nvidia driver. (worked until Sprint 4)
- Nvidia cards randomly unavaialbe
  * **Solution**: none.
  * **Workaround**: try more times. (worked until Sprint 4)
- Cannot get enough quota for volume
  * **Solution**: The administrator of MOC helped us after we asking it, fixed in 2 weeks.
- Cannot mount volumes (Keep timeout while mouting the volume)
  * **Solution**: none.
  * **Workaround**: none.
- Cannot deploy a container (Failed to pull image in OpenShift, maybe due to the DNS error in OpenShift or MOC)
  * **Solution**: none.
  * **Workaround**: none.
***

# 2. Running on Satori

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

***

# 3. Running on OpenShift on MOC

We created a docker container that runs the training process of BigGAN. We modified the instructions to run BigGAN on Satori, and use the scripts [here](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/tree/feature-gpubiggan/workflows/BigGAN/gpu).
This test used 1 GPU for training. We measured the CPU usage, GPU usage and memory usage while training. 

### CPU usage

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
