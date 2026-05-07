#!/bin/bash
# Description: Backing up $SCRATCH to UCLA Box with rclone.
#$ -cwd
#$ -o /u/scratch/a/aliceg/logs/backup-logs/rclone.$JOB_ID.out
#$ -j y
#$ -l h_data=4G,h_rt=23:00:00,highp
#$ -pe shared 16
#$ -M $USER@ucla.edu
#$ -m bea
. /u/local/Modules/default/init/modules.sh
source ~/.bashrc

timestamp="$(date +"%Y-%m-%d_%H-%M-%S")"

# Copy the full scratch directory to a timestamped Box backup.
# -P outputs current progress to the job output file specified by -o above.
# -L follows symlinks.
# --transfers 16 uses 16 parallel file transfers.
# --checkers 4 uses 4 parallel checkers to see if files are already present at the destination.
# --log-file writes successful and failed transfer logs.
# The destination timestamp avoids overwriting previous backups. You can also specify a fixed
# destination name if you want to overwrite the previous backup each time.
~/bin/rclone copy \
    -P \
    -L \
    --transfers 16 \
    --checkers 4 \
    --log-file "$SCRATCH/logs/backup-logs/scratch-${timestamp}.log" \
    --log-level INFO \
    "$SCRATCH" \
    "ucla-box:backups/scratch-${timestamp}"
