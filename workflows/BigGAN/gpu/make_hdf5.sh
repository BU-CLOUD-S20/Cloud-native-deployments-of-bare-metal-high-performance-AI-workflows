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

echo "Making hdf5..."
python3 ${WORK_DIR}/${REPO}/make_hdf5.py \
     --dataset ${DATASET} \
     --resolution ${RESOLUTION} \
     --batch_size 64 \
     --data_root ${DATA_ROOT}
echo "HDF5 done!"