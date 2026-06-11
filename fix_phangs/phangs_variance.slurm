#!/bin/bash -l
#SBATCH --account=pawsey1308
#SBATCH --partition=work
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=128
#SBATCH --mem=230G
#SBATCH --time=24:00:00
#SBATCH --job-name=phangs_variance
#SBATCH --output=phangs_variance-%j.out
#SBATCH --error=phangs_variance-%j.err
#SBATCH --mail-user=rongjun.huang@research.uwa.edu.au,astro@rongjun-huang.com
#SBATCH --mail-type=BEGIN,END,FAIL

set -euo pipefail

cd /software/projects/pawsey1308/ngist_supplementary_public/ngistTutorial/fix_phangs

export OMP_NUM_THREADS=1
export OPENBLAS_NUM_THREADS=1
export MKL_NUM_THREADS=1

WORKERS="${SLURM_CPUS_PER_TASK:-128}"

echo "Checking PHANGS STAT gaps with ${WORKERS} workers"
srun -n 1 -c "$WORKERS" ngistenv1308 ./check_phangs_variance.py --workers "$WORKERS"

echo "Fixing fillable PHANGS STAT gaps with ${WORKERS} workers"
srun -n 1 -c "$WORKERS" ngistenv1308 ./fix_phangs_variance.py --workers "$WORKERS"
