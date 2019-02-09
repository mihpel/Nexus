####################################
# Running example
```
/bin/bash tritium.sh 
```
```
Initial settings:

  UserNAME = nexus
  user uid = 1342
  user gid = 1342
  nexus build version = merging
  enable_debug = 1

Edit in file to alter the above


unrecognised option

options: <build-base> <rebuild-base> <build-code> <rebuild-code> <start> <restart> <stop>

a single option allowed at a time
```
#####################################
# Options breakdown
```
<build-base>   : *Builds base image from Dockerfile-tritium-base-ubuntu-18.04*
<rebuild-base> : *Rebuilds base image ignoring cache*
<build-code>   : *Builds code image from Dockerfile-tritium-code-ubuntu-18.04*
<build-code>   : *Rebuilds code image ignoring cache*
<start>        : *Attempts to start code container*
<restart>      : *Attempts to restart code container*
<stop>         : *Stops code container* (it's also removed since the run command includes --rm switch)
```
#####################################
# File structure
## Git
```
Tritium
├── Dockerfile-tritium-base-ubuntu-18.04 # Base Dockerimage for dependancies
├── Dockerfile-tritium-code-ubuntu-18.04 # Code Dockerfile - compile and prep helpers
├── dump_uploader.sh                     # Dropbox Uploader
├── README.md
├── reset-data.sh                        # Quick reset ~/.TAO/ excluding wallet.dat, LLL-TAO and compiled-version.txt
├── screen-watchdog.sh                   # send watchdog.sh on a screen session
├── tritium.sh                           # Main wrapper
└── watchdog.sh                          # Monitor for git commits and crashes. Conditional reactions
```
## ~/.TAO
```
├── addr
├── compiled_version.txt   # Includes the commit the running code has been build against
├── core-nexus.13.4fd3e0603ec6.1549596044 # Example crash dump
├── database
├── __db.001
├── __db.002
├── __db.003
├── __db.004
├── __db.005
├── __db.006
├── debug.log
├── docker-start.sh  # Includes the code container startup sequence. Alter directly and restart nexus container to apply changes
├── ledger
├── legacy
├── local
├── nexus.conf
├── registers
├── trust
├── uploads
└── wallet.dat
```
