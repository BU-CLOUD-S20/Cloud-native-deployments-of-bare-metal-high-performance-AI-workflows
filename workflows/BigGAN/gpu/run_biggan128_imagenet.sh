#!/bin/bash

#HOME=/home/$(whoami)
HOME=$DEVENV
WORK_DIR=$HOME
PYTHON_VIRTUAL_ENVIRONMENT=wmlce-1.6.2
CONDA_ROOT=${HOME}/anaconda3
REPO=BigGAN-PyTorch
DATA_ROOT="${WORK_DIR}/${REPO}/data" # Need to mount data to this path when starting image

source ${CONDA_ROOT}/etc/profile.d/conda.sh
conda activate $PYTHON_VIRTUAL_ENVIRONMENT

# TODO: maybe move this to a configuration file?
# It's okay for just putting here, it will be better to read it from config file.
DATASET=ImageNet
RESOLUTION=128
DATASET_TYPE=ImageFolder
N=1 # TODO: figure out what is the purpose of setting world size

TRAINFILE=$WORK_DIR/trainfile_biggan128_imagenet
rm -rf $TRAINFILE

export PAMI_IBV_ADAPTER_AFFINITY=0
export NCCL_SOCKET_IFNAME=ib

echo "Start training bigGAN..."
# TODO: Investigate if we need mpirun for container env?
# mpirun -np ${N} \

python3 ${WORK_DIR}/${REPO}/main.py \
    --model biggan_deep \
    --dataset ${DATASET} --resolution ${RESOLUTION} \
    --shuffle  --num_workers 8 --batch_size 64 \
    --data_root ${DATA_ROOT} \
    --dataset_type ${DATASET_TYPE} \
    --num_G_accumulations 1 --num_D_accumulations 1 \
    --num_D_steps 2 --G_lr 5e-5 --D_lr 2e-4 --D_B2 0.999 --G_B2 0.999 \
    --G_attn 64 --D_attn 64 \
    --G_ch 96 --D_ch 96 \
    --G_depth 2 --D_depth 2 \
    --G_nl inplace_relu --D_nl inplace_relu \
    --SN_eps 1e-6 --BN_eps 1e-5 --adam_eps 1e-6 \
    --G_ortho 0.0 \
    --G_shared \
    --G_init ortho --D_init ortho \
    --hier --dim_z 120 --shared_dim 128 \
    --ema --use_ema --ema_start 20000 --G_eval_mode \
    --test_every 2000 --save_every 500 --num_best_copies 5 --num_save_copies 2 --seed 0 \
    --world-size ${N} --dist-url file://${TRAINFILE} --gpu 1
# TODO: Test distributed workflow
