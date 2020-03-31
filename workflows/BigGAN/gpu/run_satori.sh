#!/bin/bash

HOME=/nobackup/users/$(whoami)
WORK_DIR=$HOME
PYTHON_VIRTUAL_ENVIRONMENT=wmlce-1.6.2
CONDA_ROOT=${WORK_DIR}/anaconda3
REPO=BigGAN-PyTorch
DATA_ROOT="${WORK_DIR}/${REPO}/data" # Need to mount data to this path when starting image

source ${CONDA_ROOT}/etc/profile.d/conda.sh
conda activate $PYTHON_VIRTUAL_ENVIRONMENT

# TODO: maybe move this to a configuration file?
# It's okay for just putting here, it will be better to read it from config file. -- Jing Qin
DATASET=ImageNet
RESOLUTION=128
DATASET_TYPE=ImageFolder
N=1 # TODO: figure out what is the purpose of setting world size.

# I think world size is a value that indicates how many available machines in the cluster
# After running mpirun ${N}, it will set an environment variable named OMPI_COMM_WORLD_RANK, then in main.py, the program will get this variable and save it for distributed training.
# What is RANK? You may need this helpful link: https://stackoverflow.com/questions/5399110/what-is-the-difference-between-ranks-and-processes-in-mpi
# Briefly, RANK determines how many processes will run this program, if OMPI_COMM_WORLD_RANK is 10, then the processes' ranks are in the range of [0, 10), all integers.
# Noticed that, the number of workers may not need to be the same as world size, since worker is only a logical thread on a machine, a machine can run many workers.
# In our case, we may not need this program run in distributed mode, single machine, single worker is enough.

TRAINFILE=$WORK_DIR/trainfile_biggan128_imagenet
rm -rf $TRAINFILE

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

sh setup.sh

# TODO: Separate the steps into multiple scripts and
#       monitor the output of each intermediate step.

export PAMI_IBV_ADAPTER_AFFINITY=0
export NCCL_SOCKET_IFNAME=ib

echo "Making hdf5..."
python3 ${WORK_DIR}/${REPO}/make_hdf5.py \
    --dataset ${DATASET} \
    --resolution ${RESOLUTION} \
    --data_root ${DATA_ROOT} \
    --batch_size 64
echo "HDF5 done!"

echo "Calculating inception moments..."
python3 ${WORK_DIR}/${REPO}/calculate_inception_moments.py \
    --dataset ${DATASET} \
    --resolution ${RESOLUTION} \
    --data_root ${DATA_ROOT} \
    --dataset_type ${DATASET_TYPE}
echo "Inception moments done!"

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
    --world-size ${N} --dist-url file://${TRAINFILE} --gpu 0
# TODO: Test distributed workflow


#end cpu and gpu measuring processes
kill -9 $SAR_PID
kill -9 $SMI_PID
