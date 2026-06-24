#!/bin/bash -l
#SBATCH --account=pawsey1308
#SBATCH --partition=highmem
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=128
#SBATCH --mem=980G
#SBATCH --time=96:00:00
#SBATCH --job-name=NGC4569_v3tk_v7.6.8
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err
#SBATCH --mail-user=rongjun.huang@research.uwa.edu.au,astro@rongjun-huang.com
#SBATCH --mail-type=BEGIN,END,FAIL

set -euo pipefail

module load singularity/4.1.0-slurm

cd /software/projects/pawsey1308/ngist_supplementary_public/ngistTutorial

# (Optional but usually wise) prevent oversubscription from BLAS/OpenMP libs:
export OMP_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1
export MKL_NUM_THREADS=1

# create output dir if not exist
mkdir -p /scratch/pawsey1308/mauve/products/v3tk_v7.6.8

# run + stream output to both screen (slurm out) and logfile
srun -n 1 -c $SLURM_CPUS_PER_TASK stdbuf -oL -eL \
  ngistenv1308 ngistPipeline \
  --config configFiles/NGC4569_MAUVE_MasterConfig_v7.6.8_setonix.yaml \
  --default-dir configFiles/defaultDir \
  2>&1 | tee NGC4569_v3tk_v7.6.8.log

exit ${PIPESTATUS[0]}

