########
#HEADER
########
ori_file_name=run_ramsesaton_summit_nobb_4096.lsf
alt_file_name=run_ramsesaton_summit_nobb_4096.sh
db_file_name=run_ramsesaton_summit_nobb_4096.sh
static_path=
wf_file_name
cc_main_name=OLCF
cc_main_full=Oak Ridge Leadership Computing Facility
cc_alt_name=
cc_alt_full=
sc_main_name=Summit
sc_alt_name=
exec_date=21-01-2021
proj_main_name=Cosmic Dawn III
proj_alt_name=CoDaIII
pi_name=Pierre OCVIRK
pi_email=
sim_bibcode=2022MNRAS.516.3389L 
sim_queue=slurm
sim_nnodes=4096
sim_nmpi=131072
sim_ncpu=131072
sim_ngpu=24576
sim_nthreads_total=131072
sim_nvector=32
sim_cpu_compiler=pgi
sim_accel_compiler=nvidia
modules=pgi/20.1,cuda/9.2.148



#######
#SCRIPT
#######
#! /bin/bash
# begin LSF directives
#BSUB -P AST031
#BSUB -W 24:00
#BSUB -nnodes 4096
#BSUB -alloc_flags gpumps
#BSUB -J 8192_131k  
#BSUB -o 8192_131ko.%J                                                                              
#BSUB -e 8192_131ke.%J  
#BSUB -q batch
#BSUB -B
#BSUB -N

module load pgi/20.1
module load cuda/9.2.148
cd /gpfs/alpine/ast031/proj-shared/pocvirk/CoDaIII/prod_sr/
module list

# set last snap as restart
./set_last_snap_as_restart_sr
# set ramses log file name using date
now=$(date +"%Y-%m-%d-%Hh%Mm%Ss")
printf "%s\n" $now
rlogname="ramseslog-${now}"
echo "ramseslogname = $rlogname"

# Cosmic Dawn III 4096 nodes run
jsrun --nrs 8192 --tasks_per_rs 16 --cpu_per_rs 16 --gpu_per_rs 3 --rs_per_host 2 --latency_priority GPU-CPU stdbuf -o0 ./ramses_aton_128x128x256_noHe_noZ_DS_BPASS_6DIGITS_LONGINT_IOGS-R=32-8192_ULM=4_NOMKDIR_PARTSP2 ramses.nml > $rlogname
echo "finished"
