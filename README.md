
<h1 align="center"> Project Atlas </h1> 

<h2 align="center"> Cloud Native Deployments of Bare-Metal High-Performance AI Workflows Proposal </h2> 

# Index

1. [Project Proposal](#project-proposal)
2. [Sprint Presentations](#sprint-presentations)
3. [Project Report](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/master/Report.md)

# Deployment Instructions
## 0. Get Started
### Clone the project
```
git clone https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows.git
cd Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows
```

### MIT Satori
![Satori](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/update-readme/ReadMe-image/Satori6.png)
- Satori is a GPU dense, high-performance Power 9 system developed as a collaboration between MIT and IBM. It has 64 1TB memory Power 9 nodes. Each node hosts four NVidia V100 32GB memory GPU cards. Within a node GPUs are linked by an NVLink2 network thst supports nearly to 200GB/s bi-directional transfer between GPUs. A 100Gb/s Infiniband network with microsecond user space latency connects the cluster nodes togehter.

#### To deploy on Satori do the following:

1. Get access to Satori following instructions in the [Satori Documentation](https://mit-satori.github.io/satori-basics.html)
2. Point your browse to the [Satori Open On-Demand (OOD)  portal](https://satori-portal.mit.edu/pun/sys/dashboard)
3. Set up and activate the [IBM Watson Machine Learning Community Edition (WMLCE)](https://mit-satori.github.io/satori-ai-frameworks.html#) conda environment.
4. On the top menu bar got to **Clusters -> Satori Shell Access**.
5. In the  shell get the test repo by typing  **git clone <https://github.com/alexandonian/BigGAN-PyTorch.git>**. Please read the README of that repo for an in-depth explanation of the steps we will complete.
6. Once the repo has been cloned, check out the `satori` branch with: \
`git checkout -b satori --track origin/satori`
7. Next, run the setup script with: \
`sh setup.sh` \
to prepare some data directories and symlinks. Currently, ImageNet is the only shared dataset stored on Satori under `/data/ImageNet`; however, more may be added in the future.
8. (Optional): To prepare your dataset as a single HDF5 file, please run \
`bsub < jobs/make_hdf5.lsf` \
with the appropriate parameters.
9. In order to measure sample quality during training, you will need to precompute inception moments for the datset of interest. To do this, run the corresponding lsf script with: \
`bsub < jobs/calculate_inception_moments.lsf` \
10. Now we are ready to submit our first training job, which can be done with any of the `jobs/biggan*` lsf scripts. 
```
#BSUB -L /bin/bash
#BSUB -J "BigGAN128-ImageNet"
#BSUB -o "runs/BigGAN128-ImageNet.%J"
#BSUB -e "runs/BigGAN128-ImageNet.%J.err"
#BSUB -n 4
#BSUB -R "span[ptile=1]"
#BSUB -gpu "num=2"
#BSUB -q "normal"
#
# Setup User Environement (Python, WMLCE virtual environment etc)
#
HOME2=/nobackup/users/$(whoami)
touch $HOME2/job_stats.txt
echo "job started" >> $HOME2/job_stats.txt
PYTHON_VIRTUAL_ENVIRONMENT=wmlce-1.6.2
CONDA_ROOT=$HOME2/software/anaconda3
source ${CONDA_ROOT}/etc/profile.d/conda.sh
conda activate $PYTHON_VIRTUAL_ENVIRONMENT
export EGO_TOP=/opt/ibm/spectrumcomputing
N=4
TRAINFILE=$HOME2/trainfile_biggan128_imagenet
rm -rf ${TRAINFILE}
cat > set.sh << EoF_s
#! /bin/sh
# Set up the GPUs; only one process per node should do this
if [ \${OMPI_COMM_WORLD_LOCAL_RANK} -eq 0 ]; then
  ppc64_cpu --smt                        # Verify the SMT mode
fi
EoF_s
chmod +x set.sh
mpirun --tag-output ./set.sh
# Run the program
export PAMI_IBV_ADAPTER_AFFINITY=0
export NCCL_SOCKET_IFNAME=ib
##Run jobs for CPU and GPU usage
#
# output cpu usage for all cpu cores every 5 seconds
currentDateTime=`date +%Y-%m-%d-%H:%M`
cpu_filename="cpu-training-${currentDateTime}.txt"
touch $HOME/$cpu_filename
sar -u 5 >> $HOME/$cpu_filename & SAR_CPU_PID=$!
mem_filename="mem-training-${currentDateTime}.txt"
sar -r 5 >> $HOME/$mem_filename & SAR_MEM_PID=$!
# output gpu usage for all gpus every 5 seconds
gpu_filename="gpu-training-${currentDateTime}.txt"
touch $HOME/$gpu_filename
nvidia-smi --query-gpu=gpu_name,pstate,utilization.gpu,utilization.memory  --format=csv -l 5 >> $HOME/$gpu_filename & SMI_PID=$!
#jobs for cpu and gpu usage started
mpirun -np ${N} \
python $HOME2/BigGAN-PyTorch/main.py \
    --model biggan \
    --dataset ImageNet --resolution 128 \
    --shuffle  --num_workers 2 --batch_size 256 \
    --num_G_accumulations 1 --num_D_accumulations 1 \
    --num_D_steps 2 --G_lr 5e-5 --D_lr 2e-4 --D_B2 0.999 --G_B2 0.999 \
    --G_attn 64 --D_attn 64 \
    --G_nl inplace_relu --D_nl inplace_relu \
    --SN_eps 1e-6 --BN_eps 1e-5 --adam_eps 1e-6 \
    --G_ortho 0.0 \
    --G_shared \
    --G_init ortho --D_init ortho \
    --hier --dim_z 120 --shared_dim 128 \
    --G_eval_mode \
    --G_ch 96 --D_ch 96 \
    --ema --use_ema --ema_start 20000 \
    --test_every 2000 --save_every 500 --num_best_copies 5 --num_save_copies 2 --seed 0 \
    --multiprocessing-distributed \
    --world-size ${N} --dist-url file://${TRAINFILE}
/bin/rm -f set.sh
# kill bg jobs for measuring cpu and gpu
kill -9 $SAR_PID
kill -9 $SAR_MEM_PID
kill -9 $SMI_PID
```
to start training a 128px resolution BigGAN-Deep model on ImageNet.
11. During training, it's useful to monititor various training metrics, which can be done via a Jupyter Notebook. Go back to the OOD Dashboad window (labeld **My Interactive Sessions**) and go to menu option **Interactive Apps -> Jupyter Notebook**.
12. Click the **Connect to Jupyter** button when it appears in a few moments
13. When Jupyter comes up for the first time, you may be prompted to select a kernel, If so, choose the default **Python 3 PowerAI**
14. Use the left navigation pane to find the git repo directory (**BigGAN-PyTorch**) you downloaded in step 4. Click into `BigGAN-PyTorch/notebooks` and double click on the Jupyter notebook **Monitor.ipynb**.



### MOC OpenShift
![Openshift](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/update-readme/ReadMe-image/project-banner_moc-openshift.png)
- The goal of The Massachusetts Open Cloud (MOC) OpenShift Service is to deploy and run the OpenShift container service in a production like environment to provide users of the MOC a container service for their projects. They are currently running two environments. The main service is high availability (HA) configured with multi-tenant option. The secondary service is more of a staging area that is currently being used to test configuration of GPU-enabled nodes.


# Project Proposal

## 1.   Vision and Goals Of The Project:

Atlas will serve as a bridge from existing bare-metal HPC clusters (example: Satori@MIT) to a native cloud environment for better resource utilization and price-efficiency. High-level goals of Atlas includes:
- Survey existing MIT bare-metal workloads and containerize one of them.
- Monitor and compare OpenShift workflows and bare-metal workflows.
- Generate a report that portrays the pros/cons of migrating bare-metal workflow to OpenShift environment.

## 2. Users/Personas Of The Project:

**This system will target the following users:**

- AI researchers looking to deploy **high-performance** AI workflows that are currently in a bare-metal environment, to a cloud native environment. 
- Machine learning/AI engineers looking to deploy an extant, ‘power/processing-hungry’ system to a cloud environment.
- Users seeking more privacy around their data that is transmitted to the cloud (provided by OpenShift).
- Users looking to utilize tools such as [Singularity](https://www.sylabs.io/docs/), or other virtualization systems to containerize workflows in the HPC (high-performance computing) clusters.
- A quintessential example of a user could be the MIT-IBM Watson AI laboratory looking to scale their workflows into the cloud in a discrete fashion. 
- Average users/hobbyists looking to deploy non-intensive computational processes to the cloud.


**This system will NOT target the following users:**

- Users with complex requirements who might require additional interface/systemic modification.

## 3.   Scope and Features Of The Project:
- Create any documentation and scripts that allow users to containerize existing High Performance (AI) workflows
- Generate charting that compares performance metrics (potentially with regard to: elasticity, economics, performance, data access and scalability) between bare-metal and OpenShift environments.
- Generate display (of suggestions) for ‘under-utilized’ nodes in OpenShift that could be used for running backfill workloads.
- Ability to deploy researcher workflows or code with ease from a bare metal environment to OpenShift/Kubernetes

## 4. Solution Concept
### Global Architectural Structure Of the Project:
Below is a description of the system components that are building blocks of the architectural design:
- **Scripts/Executables:** Users can write the scripts/executables to specify the commands for OpenShift and Satori.
- **Containers:** The containers include the codes of AI program. And deployed by OpenShift
- **Volumes:** Used for save training/test/validation data of AI program as well as results of the program.

> `Figure 1` below shows the overview architecture of this project.

![alt text](https://www.lucidchart.com/publicSegments/view/4f14108f-deb4-4e67-836f-cd1049b2fe00/image.png "Overview Architecture")
<p align="center">Figure 1: Global Architectural Structure Of the Project</p>

<!-- ![alt text](./imgs/../doc/imgs/overview-sequence-diagram.png "Overview Sequence Diagram")
<p align="center">Figure 2: Sequence diagram of this project</p> -->

### Design Implications and Discussion:
This section discusses the implications and reasons for the design decisions made during the global architecture design.
- **Scripts/Executables:**
In order to compare two systems benefits, the Scripts/Executables will be needed to easily upload the codes to the bare-metal system and cloud-native (OpenShift) at the same time. And the scripts/executables will be one of the most important parts of the whole workflow since it will tell how OpenShift and Satori do to make the AI workflow work, and get the returned comparison results to the users.
- **Containers:** On OpenShift, we should use **BuildConfig** to automatically build images for AI workflows and deploy them via **DeploymentConfig** as containers. **DeploymentConfig** can be triggered to deploy a new container if **BuildConfig** is triggered. Each container can only serve for one application.
- **Volumes:** For persistent storage, save data in containers or downloading data from internet every single time is not a wise choice, so we decide to use volume on OpenShift to store our data.

## 5. Acceptance criteria
The minimum acceptance criteria is an interface that is able to containerize and deploy a specific AI workflow, many of which are currently existing in the MIT HPC. The system must also be able to generate comparison metrics (on a few dimensions such as elasticity, performance, economics, etc.) between the project being run in a native cloud environment (in our case; the ‘hybrid cloud’ system, OpenShift) and a bare metal environment. Some stretch goals we hope to implement are:
- Directing resources to under-utlized nodes (or minimally displaying that there are such instances) in an effortless manner.
- Extending to a wider class of projects by circumventing the problem of workflows being tied to a current system.


## 6.  Release Planning:
`Release 1 (Week 5):` 
- Try to deploy at least one specific workflow to OpenShift
- Be able to spawn a bare metal and cloud job for a particular workflow

`Release 2 (Week 9):` 
- Write scripts that monitors both the bare-metal and cloud workflow and displays one dimension of performance in real-time
- Some preliminary form of an interface to communicate with our system 

`Release 3 (Week 13):` 
- Design a platform that, in tandem, can start both the bare metal and cloud job using https/ssh protocol.
- Interface to include detailed comparison between bare-metal env. & cloud-native implementations of parallel ML workflows.
- Display under-utilized nodes in OpenShift and perhaps suggestions/actual effectuations of running backfill overloads.


# Sprint Presentations

## Demo 1 Presentation
- Please find current updates on our project (via a presentation format) located [here!](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/master/doc/Demo%201%20Presentation.pdf)


## Demo 2 Presentation
- Please find current updates on our project (via a presentation format) located [here!](https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/blob/master/doc/Sprint%202.pdf)

## Demo 3 Presentation
- Please find current updates on our project (via a presentation format) located [here!](https://docs.google.com/presentation/d/1J1rcBpyZu0A88GTx1C0yopMndCmbD5HWALDf6Gny4CQ/edit?usp=sharing)


## Demo 4 Presentation
- Please find current updates on our project (via a presentation format) located [here!](https://docs.google.com/presentation/d/1gs5QFrgoNj_c7xnKjkHb-d1UBYfYNZ12fyD629J4mVM/edit?usp=sharing)

## Demo 5 Presentation
- Please find current updates on our project (via a presentation format) located [here!](https://docs.google.com/presentation/d/1gs5QFrgoNj_c7xnKjkHb-d1UBYfYNZ12fyD629J4mVM/edit?usp=sharing)



## Optional Features
- Automatic deploy experiments: Because tasks need to be deployed automatically, so there should have an interface or containers to automatically execute the experimental codes in two different environments.
- Generalized: orientation is mostly towards high-performance AI workflows, but should have the capability to deploy a wide range of projects. 
- Use of a 'Hybrid Cloud’ environment that will allow data to be processed either at local workstations with some nodes from AWS/GSP, or at OpenShift’s own centers (a medley of on-site, private cloud and third-party).
- Ability to operate with ease across multiple deployments (MIT HPC, MIT-IBM Watson lab, etc.).
- A easy-to-operate interface with the following features/functions:
  - Simple management of the users of the system.
  - Ability to add/deploy a wide-variety extant projects with ease.
  - Manipulation (with relatively low latency) of low-level resources such as: computing, network, storage, node allocation.
  - Simple to view instances and launch/suspend new or existing instances.
  - View existing networks.
- Ability to be scalable (a large number of users, services, projects, data) with workflows easily containerized in a timely fashion:
  - Streamlining scaling up through the following methods will also be explored:
    - Minimizing data inertia.
    - Circumventing workflow tied to a current system.
- Generalized: orientation is mostly towards high-performance AI workflows, but should have the capability to deploy a wide range of projects. 
- Generalize from supporting a specific workflow to supporting a wide range of bare-metal AI workflows that uses different machine learning frameworks.

