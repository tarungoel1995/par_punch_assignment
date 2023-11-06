Prerequisite.

1. AWS user with required access to run Terraform.
2. S3 bucket to store the terraform state.
3. export AWS_PROFILE=<Profile name>

Steps to run:

1. Base Infra

Steps: 1. go to stack directory -> environment1 ->baseinfra
       2. Do the required changes in luanch.tf
       3. Run terraform init
       4. Run terraform plan
       5. Run terraform apply
2. EKS Cluster with Calico CNI

Steps: 1. go to stack directory -> environment1 ->eks
       2. Do the required changes in launch.tf
       3. Run terraform init
       4. Run terraform plan
       5. Run terraform apply

3. Deploy dummy service with access to S3 bucket

Steps: 1. go to stack directory -> environment1 ->dummyservice
       2. Do the required changes in launch.tf
       3. Run terraform init
       4. Run terraform plan
       5. Run terraform apply
