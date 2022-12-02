#!/usr/bin/env sh
echo 'GraphDB AWS env destruction started...'
terraform_args=$1
cd /opt/terraform-data/arm64-build-on-aws
terraform destroy -auto-approve ${terraform_args}
echo "Environment destroyed"
