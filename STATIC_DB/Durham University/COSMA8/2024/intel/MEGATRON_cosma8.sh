########
#HEADER
########
ori_file_name=run_MEGATRON_CGM_REF_cosma8
alt_file_name=MEGATRON_cosma8.sh
cc_main_name=Durham University
cc_main_full=Durham University
cc_alt_name=
cc_alt_full=
sc_main_name=COSMA8
sc_alt_name=
exec_date=14-10-2024
proj_main_name=MEGATRON
proj_alt_name=
pi_name=Corentin Cadiou
pi_email=corentin.cadiou@iap.fr
sim_bibcode= 
sim_queue=slurm
sim_nnodes=32
sim_nmpi=4096
sim_ncpu=4096
sim_ngpu=0
sim_nthreads_total=4096
sim_nvector=16
sim_cpu_compiler=intel
sim_accel_compiler=
modules=intel_comp/2023.2.0,compiler,mpi



#######
#SCRIPT
#######
#SBATCH --ntasks 4096 # 1 node = 128 (64 x 2)
#SBATCH --nodes 32
#SBATCH -J JWST_a1
#SBATCH -o jwst_002_CGM_ref4.out
#SBATCH -e jwst_002_CGM_ref4.err
#SBATCH -p cosma8
#SBATCH -d singleton
#SBATCH -A REDACTED
#SBATCH -t 72:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=REDACTED

module unload openmpi
module load intel_comp/2023.2.0 compiler mpi

last_output=$(ls --color=never | grep -E '^output_[0-9]{5}$' --color=never | tail -n 1 | cut -d_ -f 2)

# Run the program
mpirun -np $SLURM_NTASKS ./ramses3d params_jwst.nml ${last_output}
