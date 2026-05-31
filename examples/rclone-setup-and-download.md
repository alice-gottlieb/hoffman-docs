# Rclone Setup and Usage

The easiest way to transfer files from box and other cloud services to Hoffman is through [rclone](https://rclone.org/). This guide will take you through 1) installing rclone in your user folder on Hoffman, 2) creating a config file on your local machine and copying it to Hoffman, and 3) transferring files, both ones you own and those shared with you.

## 1 - Installing Rclone on Hoffman ##
# rclone

**rclone** is a command line program to sync files and directories to and from cloud storage - https://rclone.org

## Installing rclone

1. Download and unzip rclone:

   ```bash
   $ wget https://github.com/rclone/rclone/releases/download/v1.74.2/rclone-v1.74.2-linux-amd64.zip
   $ unzip rclone-v1.51.0-linux-amd64.zip
   ```

2. Move the rclone executable to your `$HOME/bin` directory. If the copy fails, you need to create `$HOME/bin` subdirectory, e.g. `mkdir $HOME/bin`:

   ```
   $ mv rclone-v1.74.2-linux-amd64/rclone $HOME/bin/.
   ```

To validate your install type:

```
$ rclone --version
```

## 2 - Configuring Rclone ##
It's easiest to configure rclone on your local computer and then copy that configuration file to Hoffman. If configuring on your local computer and copying to Hoffman fails, follow the directions at https://www.hoffman2.idre.ucla.edu/Using-H2/Data-transfer.html#configuring-rclone with X11 forwarding to configure directly on the server.

1. Download and install rclone on your local computer by downloading the appropriate release from https://rclone.org/downloads/ . 

2. On your local machine, run 
```bash
$ rclone config
```

3. Select `n` for `new remote` and enter a name
```bash
e) Edit existing remote
n) New remote
d) Delete remote
r) Rename remote
c) Copy remote
s) Set configuration password
q) Quit config
e/n/d/r/c/s/q> n
```

```
Enter name for new remote.
name> ucla-box
```

4. From the list, select `box`

```
Storage> box
```

5. Leave `client_id`, `client_secret`, `box_config_file` and `access_token` empty by pressing enter:
```
Option client_id.
OAuth Client Id.
Leave blank normally.
Enter a value. Press Enter to leave empty.
client_id> 

Option client_secret.
OAuth Client Secret.
Leave blank normally.
Enter a value. Press Enter to leave empty.
client_secret> 

Option box_config_file.
Box App config.json location
Leave blank normally.
Leading `~` will be expanded in the file name as will environment variables such as `${RCLONE_CONFIG_DIR}`.
Enter a value. Press Enter to leave empty.
box_config_file> 

Option access_token.
Box App Primary Access Token
Leave blank normally.
Enter a value. Press Enter to leave empty.
access_token>
```

5. Choose `1` for `user`
```
Choose a number from below, or type in your own value of type string.
Press Enter for the default (user).
 1 / Rclone should act on behalf of a user.
   \ (user)
 2 / Rclone should act on behalf of a service account.
   \ (enterprise)
box_sub_type> 1
```

6. Type `n` to allow the default config
```
Edit advanced config?
y) Yes
n) No (default)
y/n> n
```

7. Type `y` to allow web browser config
```
Use web browser to automatically authenticate rclone with remote?
 * Say Y if the machine running rclone has a web browser you can use
 * Say N if running rclone on a (remote) machine without web browser access
If not sure try Y. If Y failed, try N.

y) Yes (default)
n) No
y/n> y
```

8. Wait for your web browser to open and sign in with your UCLA credentials in the browser window

9. Type `y` to accept the setting and save this configuration
```
y) Yes this is OK (default)
e) Edit this remote
d) Delete this remote
y/e/d> y
```

10. Find where you local rclone config file is stored by running
``` 
$ rclone config file
PATH/TO/YOUR/LOCAL/CONFIG/rclone.conf
```

11. Use `scp`, `rsync`, or another method to transfer the your local config from `PATH/TO/YOUR/LOCAL/CONFIG/rclone.conf` to `$HOME/rclone/rclone.conf` on Hoffman.

12. On Hoffman, run
```
$ rclone list remotes
```
Which should show you 
```
ucla-box:
```

## 3 - Transferring Files ##
Follow the examples at [rclone.org](rclone.org) to use `copy`, `sync` and similar commands for one-time or relatively small-file size usage. If you want to use rclone in an interactive session, ssh into Hoffman and then run
```
$ ssh dtn 
```
to access a data-transfer node with faster networking capabilities. 

### qsub Example ###
For recurring or large scale rclone runs, you can submit a job script with `qsub`. This has the advantage of allowing multiple cores, which is especially useful for transfer with a very large number of files. Follow the example in [rclone-backup.sh](rclone-backup.sh), which copies the entire scratch directory to a timestamped scratch backup folder in Box.

Example `rclone-backup.sh`:

```bash
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
```

### Shared Links ###
In order to download files shared with you by box link, open the box link in the browser and click **Save Link**.

![Box shared link save button](shared-link-download.png)

Then, you will see the files shared with you in a location in your personal Box file system. You can simply use `rclone copy` or `rclone sync` to download those files to your desired location in Hoffman.  