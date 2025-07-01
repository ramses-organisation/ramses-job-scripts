### RAMSES SLURM DB

########
#HEADER
########
ori_file_name=irene_rome.sh
alt_file_name=
db_file_name=
db_path=
cc_main_name=TGCC
cc_main_full=Très Grand Centre de Calcul du CEA
cc_alt_name=
cc_alt_full=
sc_main_name=irene
sc_alt_name=
exec_date=01-11-2024
exec_year=2024
pi_name=Noé Brucy
pi_email=
sim_queue=slurm
sim_nnodes=4
sim_nmpi=512
sim_ncpu=512
sim_ngpu=0
sim_nthreads_total=512
sim_cpu_compiler=gnu
modules=mpi/openmpi

#######
#SCRIPT
#######
#! /bin/bash
# begin LSF directives


#!/bin/bash 
#MSUB -r [simulation name]          # Simulation name 
#MSUB -n 512                        # Number of tasks to use
#MSUB -T 86400                      # Elapsed time limit in seconds 
#MSUB -o ramses_%I.o                # Standard output. %I is the job id 
#MSUB -e ramses_%I.e                # Error output. %I is the job id
#MSUB -q standard                   # type of queue 
#MSUB -A [allocation name]          # Project ID
#MSUB -q rome             # partition
#MSUB -w                  # wait if a job with same name is already running
#MSUB -E "--no-requeue"   # avoid resubmit with same ID if job fails
#MSUB -m scratch          # use the 


module switch mpi/openmpi

export RUN=run.log%I

set -x 

nrestart="$(find . -maxdepth 1 -name output_'?????' | sort -n | tail -c 6)" # get the last snapshot

ccc_mprun ./ramses3d run.nml ${nrestart}  < /dev/null > run.log.$BRIDGE_MSUB_JOBID
