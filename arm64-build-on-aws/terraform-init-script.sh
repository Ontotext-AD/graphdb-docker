#!/usr/bin/env sh
echo 'GraphDB AWS env deployment started...'
terraform_args=$1
cd /opt/terraform-data/arm64-build-on-aws
terraform init -upgrade
echo "Terraform initialized"
echo ${terraform_args}
terraform apply -auto-approve ${terraform_args}
#terraform plan ${terraform_args}
echo "Terraform deployment finished"
echo "Destroying the machine"
terraform destroy -auto-approve ${terraform_args}
