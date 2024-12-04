# ramses-job-scripts
# RAMSES SLURM DATABASE

- Draft document by Pierre OCVIRK, 19/09/2024
- Updated 04/12/2024

## QUICK SUMMARY: HOW TO SUBMIT YOUR SCRIPTS TO THE DATABASE

If you are in a hurry, read only this!\
The scripts are to be deposited here:\
https://seafile.unistra.fr/d/7cf0c55d4a0447a8aba5/

With the minimal mandatory header (only 11 easy header fields), the script should look like this:

########\
#HEADER\
########

ori_file_name=run_ramsesaton_summit_nobb_4096.lsf\
cc_main_name=OLCF\
sc_main_name=Summit\
exec_year=2021\
pi_name=Pierre OCVIRK\
sim_queue=slurm\
sim_nnodes=4096\
sim_nmpi=131072\
sim_ncpu=131072\
sim_nthreads_total=131072\
sim_cpu_compiler=pgi\

#######\
#SCRIPT\
#######\
#Your script goes here\
#! /bin/bash\
#begin LSF directives

#BSUB -P AST031\
#BSUB -W 24:00\
#BSUB -nnodes 4096\
#BSUB -alloc_flags gpumps\
...

A longer form, more detailed of the document and possible metadata follows below for the more patient reader.

## Context

The purpose of this document is to help organize the RAMSES Slurm DB (RSDB) working group.

The RSDB is an attempt at improving the user experience when deploying RAMSES on computing centers. Depending on the queue system, 
the heterogeneity of the compute resources, the quality of documentation, and the complexity of the simulation at hand and its 
management of data, generating/adapting a generic SLURM script as provided by the HPC center documentation can be time-consuming 
and frustrating, particularly for new users. The RSDB WG aims at creating a database of such scripts for users to support 
deployment of RAMSES and speed up progress towards production.

## Structure / Content / Metadata

The main structure of the DB is given further below, and a number of repo have been setup for this purpose.
A number of principles and requirements have also been formulated:

- The SLURM scripts ingested in the DB will be sourced from the community
- Each script should be provided with metadata allowing quick and efficient understanding of the compute profile and context. A 
metadata template will be provided to the community.
- The DB should be easily accessible, both for uploading and viewing/downloading scripts.
- Upload is here: https://seafile.unistra.fr/d/7cf0c55d4a0447a8aba5/
- Test DB could be here: https://seafile.unistra.fr/d/3d5a5d9d8f764bfebd62/
- Official DB lives on GitHub for easy cloning: https://github.com/ramses-organisation/ramses-job-scripts/

The DB is curated by RSDB steward(s). The role of these stewards is several fold:
- Retrieve the user-uploaded scripts from a TBD repo, on a regular basis (once per week / every other week / once a month)
  - => AT RUM2025
- Review the scripts to verify/assess provenance and conformity of metadata, if necessary interact with the author to clarify.
- Ingest into the main DB.

There is a Seafile repo for upload from users, and a GitHub repo for download to users. The steward makes the link between the two.

### Data Model

Several metadata items have been identified and are presented in the table below:

| Item | Keyword | Type, Format | Mandatory/Desirable/Optional |
|------|---------|--------------|------------------------------|
| Computing center name main acronym | cc_main_name | String, "" | Mandatory |
| Computing center developed acronym | cc_main_full | String, "" | Desirable |
| Computing center name alt acronym | cc_alt_name | String, "" | Optional |
| Computing center developed alt acronym | cc_alt_full | String, "" | Optional |
| Supercomputer name main | sc_main_name | String, "" | Mandatory |
| Supercomputer name alt | sc_alt_name | String, "" | Optional |
| Execution date | exec_date | String, "dd-mm-yyyy" | Optional |
| Execution year | exec_year | String, "yyyy" | Mandatory |
| Simulation project name main (e.g. short) | proj_main_name | String, "" | Desirable |
| Simulation project name alt (e.g. long) | proj_alt_name | String, "" | Desirable |
| Principal Investigator / author / uploader | pi_name | String, "" | Mandatory |
| Principal Investigator email | pi_email | String, "" | Optional |
| Associated publication bibcode | sim_bibcode | String, "" | Desirable |
| Queue management system (slurm / sbatch / bsub / other) | sim_queue | String, "" | Mandatory |
| NNODES | sim_nnodes | int | Mandatory |
| NMPI domains | sim_nmpi | int | Mandatory |
| NCPU | sim_ncpu | int | Mandatory |
| NGPU | sim_ngpu | int | Optional (0) if no GPU |
| NTHREADS_TOTAL | sim_nthreads_total | int | Mandatory |
| NVECTOR | sim_nvector | int | Optional |
| Cpu Compiler: pgi/intel/gnu/cray | sim_cpu_compiler | String, "" | Mandatory |
| Accelerator compiler: nvidia/amd/intel | sim_accel_compiler | String, "" | Optional |
| Modules | sim_modules | Comma-separated list,"," | Desirable |
| Original Filename | ori_file_name | String, "" | Mandatory |
| Alt filename | alt_file_name | String, "" | Leave blank / Workflow-assigned |
| Database filename | db_file_name | String, "" | Leave blank / Workflow-assigned |
| Static DB path | db_path | String, "" | Leave blank / Workflow-assigned |

## Example SLURM Script with Metadata

```bash
### RAMSES SLURM DB

########
#HEADER
########
ori_file_name=run_ramsesaton_summit_nobb_4096.lsf
alt_file_name=
db_file_name=
db_path=
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
jsrun --nrs 8192 --tasks_per_rs 16 --cpu_per_rs 16 --gpu_per_rs 3 --rs_per_host 2 --latency_priority GPU-CPU stdbuf -o0 
./ramses_aton_128x128x256_noHe_noZ_DS_BPASS_6DIGITS_LONGINT_IOGS-R=32-8192_ULM=4_NOMKDIR_PARTSP2 ramses.nml > $rlogname

echo "finished"
```

## Indexation and Repository Structure

### 1 - STATIC_DB

The static DB will be a repository with the following structure:
- Computing Center
  - Computer
    - Execution year
      - Compiler

This structure is useful for a web-based exploration of the DB in a browser.

### 2 - Dynamic, Python-queryable DB

The full DB is anticipated to be small enough to be wholly downloadable by users in one tarball. A registry file will contain the 
metadata of all the SLURM files, in a Python dictionary structure. Using this file it should be easy to make queries such as:
- What is the most recent SLURM executed on Jean Zay?
- Show me the 3 largest runs in terms of MPI parallelism
- Show me the SPHINX production run SLURM script

The structure for this will be a GitHub repo containing the DB data and a few Python scripts to read the metadata registry.

