#!/bin/bash

HOME=`pwd`
WORK_DIR=${HOME}/work/
DATA_ROOT="/data/"

# TODO: maybe move this to a configuration file?
DATASET=ImageNet
RESOLUTION=128
DATASET_TYPE=ImageFolder
TRAIN_FILE=${WORK_DIR}/trainfile_biggan_deep128_imagenet
N=1

mkdir ${WORK_DIR} && cd ${WORK_DIR}
# TODO: mount imagenet data to the image during runtime?
# TODO: data_root should be configurable
mkdir -p data && ln -s ${DATA_ROOT}/ImageNet data/ImageNet

cd ${WORK_DIR}
git clone https://github.com/shawn3298317/BigGAN-PyTorch.git
cd ${WORK_DIR}/BigGAN-PyTorch/
git checkout -b satori --track origin/satori

echo "Making hdf5..."
python3 ${WORK_DIR}/BigGAN-PyTorch/make_hdf5.py \
    --dataset ${DATASET} \
    --resolution ${RESOLUTION} \
    --data_root ${DATA_ROOT}
echo "HDF5 done!"

echo "Calculating inception moments..."
python3 ${WORK_DIR}/BigGAN-PyTorch/calculate_inception_moments.py \
    --dataset ${DATASET} \
    --resolution ${RESOLUTION} \
    --data_root ${DATA_ROOT} \
    --dataset_type ${DATASET_TYPE}
echo "Inception moments done!"


echo "Start training bigGAN..."
# TODO: Investigate if we need mpirun for container env?
# mpirun -np ${N} \
python3 ${WORK_DIR}/BigGAN-PyTorch/main.py \
    --model biggan_deep \
    --dataset ${DATASET} --resolution ${RESOLUTION} --shuffle  --num_workers 8 --batch_size 2 \
    --dataset_type ${DATASET_TYPE} \
    --num_G_accumulations 1 --num_D_accumulations 1 \
    --num_D_steps 2 --G_lr 5e-5 --D_lr 2e-4 --D_B2 0.999 --G_B2 0.999 \
    --G_attn 64 --D_attn 64 \
    --G_ch 128 --D_ch 128 \
    --G_depth 2 --D_depth 2 \
    --G_nl inplace_relu --D_nl inplace_relu \
    --SN_eps 1e-6 --BN_eps 1e-5 --adam_eps 1e-6 \
    --G_ortho 0.0 \
    --G_shared \
    --G_init ortho --D_init ortho \
    --hier --dim_z 128 --shared_dim 128 \
    --ema --use_ema --ema_start 20000 --G_eval_mode \
    --test_every 2000 --save_every 500 --num_best_copies 5 --num_save_copies 2 --seed 0 \
    --world-size ${N}
    #--dist-url file://${TRAINFILE}
    #--multiprocessing-distributed \

