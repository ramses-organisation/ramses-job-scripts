########
#HEADER
########
ori_file_name=run_vintergatan_mare_nostrum
alt_file_name=mare_nostrum_script.sh
cc_main_name=BSC
cc_main_full=Barcelona Supercomputing Center
cc_alt_name=
cc_alt_full=
sc_main_name=Mare Nostrum
sc_alt_name=
exec_date=14-10-2024
proj_main_name=Vintergatan 2
proj_alt_name=VG2
pi_name=Corentin Cadiou
pi_email=corentin.cadiou@iap.fr
sim_bibcode= 
sim_queue=slurm
sim_nnodes=9
sim_nmpi=1008
sim_ncpu=1008
sim_ngpu=0
sim_nthreads_total=1008
sim_nvector=32
sim_cpu_compiler=intel
sim_accel_compiler=
modules=intel/2023.2.0



#######
#SCRIPT
#######
#!/bin/bash
#SBATCH -J halo685
#SBATCH -A REDACTED
#SBATCH -q gp_resa
# Least common multiple between COSMOS (48) and Mare Nostrum (112) is 336
# Let's roll with 1008 = 6 MN nodes
#                      = 21 COSMOS nodes
#SBATCH -N 9
#SBATCH -n 1008
#SBATCH --time=72:00:00
#SBATCH --requeue
#SBATCH --exclusive
#SBATCH -d singleton
#SBATCH --mail-type=all
#SBATCH --mail-user=REDACTED

module load intel

echo Working directory is $(pwd)
set -x

# Find restart output
NOUTPUT=$(ls | grep -E 'output_.....' | wc -l)

if [[ $NOUTPUT == 0 ]]; then
    PARAMFILE=params_start.nml
else
    PARAMFILE=params.nml
fi

RAMSES=ramses3d
# RAMSES=ramses3d_debug

srun -n 1008 ${RAMSES} ${PARAMFILE} ${NOUTPUT}

