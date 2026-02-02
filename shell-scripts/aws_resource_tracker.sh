#!/bin/bash

########################
# Author: Kushagra
# Date: 28th-Jan-26
# 
# Version: v1
#
# This script will report the AWS resource usage
##########################

set -x

# Aws S3
# Aws Ec2
# Aws Lambda
# Aws IAM users


# list s3 buckets
echo "print list of s3 buckets"
aws s3 ls

# list Ec2 instances
echo "print list of ec2 instances"
aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId'

# list lambda
echo "print list of lambda functions"
aws lambda list-functions

# list Iam users
echo "print list of iam users"
aws iam list-users
