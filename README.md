Terraform AWS EC2 Setup and Backup Script
This project contains Terraform configurations to provision an AWS EC2 instance and deploy a backup script that runs daily. The backup script compresses a specified directory and uploads the backup to an S3 bucket.

Project Structure:

main.tf: Main Terraform configuration file.
variables.tf: File containing the variable definitions.
backup-script.sh: Bash script that creates and uploads the backup.
iam.tf: Terraform configuration for IAM roles and policies.

Requirements:

Terraform v0.12+
AWS CLI configured with appropriate credentials
An existing S3 bucket named my-backup-bucket
SSH key pair for accessing the EC2 instance

Usage
1. Clone the Repository
   git clone git@github.com:AnushaMNair93/terraform-ec2-backup.git
   cd terraform-ec2-setup
2. Update Variables
   Edit variables.tf to update any default values if necessary.
3. terraform init
4. terraform plan
5. terraform apply
6. Verify the Setup
   After Terraform has applied the configuration, it will output the public IP address of the EC2 instance. SSH into the instance to verify the cron job and backup script.
   ssh -i ~/.ssh/id_rsa ec2-user@<public-ip>
7. Check Cron Job
   On the EC2 instance, verify the cron job is set up correctly:
   crontab -l

Cleanup:

To destroy the resources created by Terraform, run:
terraform destroy

Files:

main.tf
Contains the main Terraform configuration to provision the EC2 instance, set up security groups, and deploy the backup script.

variables.tf
Defines variables for the AWS region, instance type, AMI ID, and S3 bucket name to make the configuration more flexible and reusable.

backup-script.sh
Bash script that creates a compressed backup of a specified directory and uploads it to the S3 bucket.

iam.tf
Defines IAM roles and policies required for the EC2 instance to interact with the S3 bucket securely.
