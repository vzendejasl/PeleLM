#!/bin/bash

#SBATCH --ntasks=128
#SBATCH --ntasks-per-node=64
#SBATCH -C knl
#SBATCH -q debug
#SBATCH -A m2860
#SBATCH -J FIAB_00128_proc_Intel_KNL
#SBATCH -t 00:30:00
#SBATCH -L SCRATCH
#SBATCH -o FIAB_00128_proc_Intel_KNL.%j.out
#SBATCH -S 4
#SBATCH --mail-type=ALL,TIME_LIMIT_50,TIME_LIMIT_80,TIME_LIMIT_90,TIME_LIMIT

EXE_DIR="${HOME}/PeleLM/Exec/FlameInABox"
EXE="PeleLM3d.intel.mic-knl.MPI.ex"

INPUTS_DIR=${PWD}
INPUTS="inputs.3d-regt_128proc"

PROBIN_DIR=${PWD}
PROBIN="probin.3d.test"

EXTRA="amr.plot_files_output=0 max_step=1 amrex.signal_handling=0 init_shrink=0.1"

WORKDIR=${SCRATCH}/${SLURM_JOB_NAME}.${SLURM_JOB_ID}
mkdir -p ${WORKDIR}
cp ${EXE_DIR}/${EXE} ${INPUTS_DIR}/${INPUTS} ${PROBIN_DIR}/${PROBIN} ${WORKDIR}
cd ${WORKDIR}

sbcast --compress=lz4 ./${EXE} /tmp/${EXE}
srun -n 128 -c 4 --cpu-bind=cores /tmp/${EXE} ${INPUTS} ${EXTRA}
