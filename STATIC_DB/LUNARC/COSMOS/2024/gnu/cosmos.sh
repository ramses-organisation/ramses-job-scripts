########
#HEADER
########
ori_file_name=run_vintergatan_
alt_file_name=cosmos.sh
cc_main_name=LUNARC
cc_main_full=The Centre for Scientific and Technical Computing at Lund University
cc_alt_name=
cc_alt_full=
sc_main_name=COSMOS
sc_alt_name=
exec_date=14-10-2024
proj_main_name=Vintergatan 2
proj_alt_name=VG2
pi_name=Corentin Cadiou
pi_email=corentin.cadiou@iap.fr
sim_bibcode= 
sim_queue=slurm
sim_nnodes=16
sim_nmpi=768
sim_ncpu=768
sim_ngpu=0
sim_nthreads_total=768
sim_nvector=32
sim_cpu_compiler=gnu
sim_accel_compiler=
modules=foss/2022b



#######
#SCRIPT
#######
#!/bin/bash
#SBATCH -J RAMSES_7.5keV
#SBATCH -A REDACTED
#SBATCH --nodes=16
#SBATCH --ntasks-per-node=48
#SBATCH --cpus-per-task=1
#SBATCH -d singleton
#SBATCH --exclusive
#SBATCH --time=7-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=REDACTED
#SBATCH --signal=10@1200


module load foss/2022b

set -xe

# Find restart output
# Find restart output
NOUTPUT=$(ls | grep -E 'output_.....' | wc -l)

if [[ $NOUTPUT == 0 ]]; then
    PARAMFILE=params_start.nml
else
    PARAMFILE=params.nml
fi

mpirun -np ${SLURM_NPROCS} ramses3d ${PARAMFILE} ${NOUTPUT}
