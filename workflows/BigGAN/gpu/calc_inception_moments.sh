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

echo "Calculating inception moments..."
python3 ${WORK_DIR}/${REPO}/calculate_inception_moments.py \
     --dataset ${DATASET} \
     --resolution ${RESOLUTION} \
     --data_root ${DATA_ROOT} \
     --dataset_type ${DATASET_TYPE} \
     --num_workers 1 \
     --batch_size 64
echo "Inception moments done!"