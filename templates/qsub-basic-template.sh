#!/bin/bash
# Description: Minimum qsub template.
#$ -cwd
#$ -o {OUTPUT_LOG_FILE_NAME}
#$ -j y
#$ -l {RESOURCES} {e.g. h_vmem=4G,h_rt=}
#$ -M $USER@ucla.edu
#$ -m bea

# Source module system and user profile
. /u/local/Modules/default/init/modules.sh
source ~/.bashrc

# Your Code here
