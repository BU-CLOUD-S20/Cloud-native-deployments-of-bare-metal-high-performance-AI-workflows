#!/bin/bash

#!/bin/bash
HOME=/home/$(whoami)
WORK_DIR=$HOME
PYTHON_VIRTUAL_ENVIRONMENT=wmlce
CONDA_ROOT=${HOME}/anaconda
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

git clone https://github.com/alexandonian/BigGAN-PyTorch.git $WORK_DIR/$REPO
cd $WORK_DIR/$REPO
git checkout satori

sh setup.sh

export PAMI_IBV_ADAPTER_AFFINITY=0
export NCCL_SOCKET_IFNAME=ib

sh ./make_hdf5.sh
sh ./calc_inception_moments.sh
sh ./run_biggan128_imagenet.sh
