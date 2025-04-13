# aws firehose data pipeline - terraform script

Certainly! To deploy the AWS Firehose Data Pipeline using Terraform, please follow the steps below:

**Prerequisites:**

1. **Install Required Tools:**
   - **Terraform:** Download and install Terraform from the [official website](https://www.terraform.io/downloads.html).
   - **AWS CLI:** Install the AWS Command Line Interface from the [AWS CLI page](https://aws.amazon.com/cli/).
   - **Docker:** Install Docker from the [Docker website](https://www.docker.com/get-started).

2. **AWS Credentials:**
   - Configure your AWS credentials by running `aws configure` and providing your AWS Access Key ID, Secret Access Key, default region, and output format.

**Deployment Steps:**

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/khanahmedm/aws-firehose-data-pipeline-terraform.git
   ```


2. **Navigate to the Project Directory:**
   ```bash
   cd aws-firehose-data-pipeline-terraform
   ```


3. **Initialize Terraform:**
   ```bash
   terraform init
   ```


4. **Review and Customize Variables:**
   - Examine the `variables.tf` files within each module in the `modules/` directory.
   - Adjust any default values as necessary to match your desired configuration.

5. **Validate the Terraform Configuration:**
   ```bash
   terraform validate
   ```


6. **Plan the Deployment:**
   ```bash
   terraform plan
   ```


7. **Apply the Terraform Configuration:**
   ```bash
   terraform apply
   ```

   - Type `yes` when prompted to confirm the deployment.

8. **Build and Push the Docker Image:**
   - Ensure Docker is running on your system.
   - Execute the provided `build_and_push.sh` script:
     ```bash
     ./build_and_push.sh <AWS_ACCOUNT_ID>
     ```
     Replace `<AWS_ACCOUNT_ID>` with your actual AWS Account ID.
   - **Note for Windows Users:**
     - If you're using Git Bash on Windows, ensure that Docker is configured to work with your shell environment.
     - You may need to adjust execution permissions or modify the script to run in a Windows-compatible shell.

9. **Verify the Deployment:**
   - Log in to the AWS Management Console.
   - Navigate to the respective AWS services (e.g., S3, Kinesis Firehose, Lambda, ECS) to confirm that the resources have been created and are functioning as expected.

**Cleanup:**

- To destroy all resources created by Terraform:
  
```bash
  terraform destroy
  ```

  - Type `yes` when prompted to confirm the destruction.
  - **Important:** This action will delete all resources provisioned by Terraform. Ensure that you have backed up any necessary data before proceeding.

**Additional Notes:**

- **Resource Naming Conflicts:**
  - If certain resources (e.g., IAM roles, ECR repositories) already exist in your AWS account, Terraform may encounter errors during creation.
  - To resolve this, you can either:
    - Manually import the existing resources into your Terraform state using `terraform import`.
    - Modify the Terraform configurations to use unique names for the conflicting resources.

- **AWS Region:**
  - Ensure that all AWS resources are being created in the desired region.
  - You can set the region by modifying the `providers.tf` file or by setting the `AWS_REGION` environment variable.

- **Permissions:**
  - Ensure that the AWS credentials used have the necessary permissions to create and manage the resources defined in the Terraform configurations.

By following these steps, you should be able to deploy the AWS Firehose Data Pipeline using the provided Terraform scripts. 