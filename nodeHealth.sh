#!/bin/bash

################################
# Author: Kushagra
# Date: 26/01/2026
#
# The Script Outputs the Node Health
#
# Version: v1
###############################

echo "Print the disk space"
df -h

echo "Print the memory"
free -g

echo "Print the cpu"
nproc
