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

git clone https://github.com/alexandonian/BigGAN-PyTorch.git $WORK_DIR/$REPO
cd $WORK_DIR/$REPO
git checkout satori

# mkdir -p data/ImageNet/train
# cd data/ImageNet/train
# wget -O list_of_images.txt "http://image-net.org/api/text/imagenet.synset.geturls?wnid=n02084071"
# wget -i list_of_images.txt -T 0.2 -t 1
# cd $WORK_DIR/$REPO

mkdir -p data/ImageNet && ln -s /data/ImageNet/ILSVRC2012/train data/ImageNet/train
mkdir runs

# Set up symlinks for the example notebooks
bash notebooks/setup_notebooks.sh

export PAMI_IBV_ADAPTER_AFFINITY=0
export NCCL_SOCKET_IFNAME=ib

bash $WORK_DIR/atlas/workflows/BigGAN/gpu/make_hdf5.sh
bash $WORK_DIR/atlas/workflows/BigGAN/gpu/calc_inception_moments.sh
bash $WORK_DIR/atlas/workflows/BigGAN/gpu/run_biggan128_imagenet.sh
