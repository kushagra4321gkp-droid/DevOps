#!/bin/bash

################################
# Author: Kushagra
# Date: 26/01/2026
#
# The Script Outputs the Node Health
#
# Version: v1
###############################

set -x # debug mode
set -e # Exits the Script when there is an Error -> It will only check the authenticity of your last command
set -o pipefail # Drawback of 'set -e' is it will not ErrorOut when there is a Pipe in the command

df -h

free -g

nproc

ps -ef

My name is Kushagra Tiwari!
I am a DevOps Engineer

#grep name | awk-F" " '{print $2}' <- Use this Command to Specify a perticular Column to Fetch


