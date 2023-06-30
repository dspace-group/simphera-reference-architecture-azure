#!/bin/bash

#SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# run terraform apply and redirect stderr to stdout
cd /src
terraform init
OUTPUT=`terraform apply --var-file="terraform.tfvars.example" -input=false 2>&1 >/dev/null`
echo $OUTPUT
# ignore az login
if [[ $OUTPUT == *"az login"* ]]; then
  exit 0
else
  exit 1
fi