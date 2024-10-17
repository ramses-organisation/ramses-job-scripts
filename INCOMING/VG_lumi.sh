########
#HEADER
########
ori_file_name=run_vintergatan_lumi
alt_file_name=VG_lumi.sh
cc_main_name=LUMI
cc_main_full=LUMI
cc_alt_name=
cc_alt_full=
sc_main_name=LUMI
sc_alt_name=
exec_date=14-10-2024
proj_main_name=Vintergatan 2
proj_alt_name=VG2
pi_name=Corentin Cadiou
pi_email=corentin.cadiou@iap.fr
sim_bibcode= 
sim_queue=slurm
sim_nnodes=12
sim_nmpi=1536
sim_ncpu=1536
sim_ngpu=0
sim_nthreads_total=1536
sim_nvector=32
sim_cpu_compiler=gnu
sim_accel_compiler=
modules=LUMI/23.09,partition/C,cpeGNU/23.09



#######
#SCRIPT
#######
#!/bin/bash
#SBATCH -J halo714_hires
#SBATCH -A REDACTED
#SBATCH -p standard
#SBATCH --ntasks=1536
#SBATCH -d singleton
#SBATCH --exclusive
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=REDACTED
#SBATCH --signal=10@2820

module load LUMI/23.09  partition/C
module load cpeGNU/23.09

export FI_CXI_RX_MATCH_MODE=hybrid

set -xe

# Where am I?
pwd

# Find restart output
NOUTPUT=$(ls | grep -E 'output_.....' | wc -l)
LAST_OUTPUT=$(ls --color=never | grep -E 'output_.....' | tail -n1 | cut -d _ -f 2)

if [[ $NOUTPUT == 0 ]]; then
    PARAMFILE=params_start.nml
else
    PARAMFILE=params.nml
fi

srun ramses3d $PARAMFILE $LAST_OUTPUT
