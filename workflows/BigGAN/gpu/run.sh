#!/bin/bash

HOME=/home/pwrai
WORK_DIR=$HOME
PYTHON_VIRTUAL_ENVIRONMENT=wmlce
CONDA_ROOT=/home/pwrai/anaconda
REPO=BigGAN-PyTorch
DATA_ROOT="${WORK_DIR}/${REPO}/data" # Need to mount data to this path when starting image

DATASET=ImageNet
RESOLUTION=128
DATASET_TYPE=ImageFolder

source ${CONDA_ROOT}/etc/profile.d/conda.sh
conda activate $PYTHON_VIRTUAL_ENVIRONMENT

if [[ -d $WORK_DIR/$REPO ]]; then
  rm -rf $WORK_DIR/$REPO
fi


# output cpu usage for all cpu cores every 5 seconds
currentDateTime=`date +%Y-%m-%d-%H:%M`
filename="cpuUsage-${currentDateTime}.txt"
touch $WORK_DIR/$filename
sar -u 5 >> $WORK_DIR/$filename & SAR_PID=$!

# output gpu usage for all gpus every 5 seconds
gpu_filename="gpuUsage-${currentDateTime}.txt"
touch $WORK_DIR/$gpu_filename
nvidia-smi --query-gpu=gpu_name,pstate,utilization.gpu,utilization.memory  --format=csv -l 5 >> $WORK_DIR/$gpu_filename & SMI_PID=$!


git clone https://github.com/alexandonian/BigGAN-PyTorch.git $WORK_DIR/$REPO
cd $WORK_DIR/$REPO
git checkout satori

mkdir -p data/ImageNet && ln -s /data/ImageNet/ILSVRC2012/train data/ImageNet/train
mkdir runs

# Set up symlinks for the example notebooks
bash notebooks/setup_notebooks.sh

export PAMI_IBV_ADAPTER_AFFINITY=0
export NCCL_SOCKET_IFNAME=ib

bash $WORK_DIR/atlas/workflows/BigGAN/gpu/make_hdf5.sh
bash $WORK_DIR/atlas/workflows/BigGAN/gpu/calc_inception_moments.sh
bash $WORK_DIR/atlas/workflows/BigGAN/gpu/run_biggan128_imagenet.sh


#end cpu and gpu measuring processes
kill -9 $SAR_PID
kill -9 $SMI_PID
