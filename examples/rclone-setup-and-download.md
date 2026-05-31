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


## 3 - Transferring Files ##
### qsub Example ###

### Shared Links ###