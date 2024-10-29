# Production-Ready EKS Infrastructure for SaaS on AWS

Welcome to the repository for our comprehensive series on building a complete, production-ready infrastructure for a SaaS application on AWS! This series will walk you through each step of creating a fully functional, secure, and scalable Amazon Elastic Kubernetes Service (EKS) cluster, along with essential components and tools to support a robust SaaS platform.

## Overview

This repository accompanies the first article in our series, where we focus on establishing the foundation of our infrastructure by constructing a robust Virtual Private Cloud (VPC). Using Terraform, we will provision a VPC tailored for security, scalability, and seamless integration with the other components we'll build in future articles.

## What You'll Learn

- **Infrastructure-as-Code with Terraform**: Automate the creation of AWS resources.
- **VPC Design**: Set up a secure, high-availability network environment.
- **Best Practices**: Implement scalable, production-ready architecture.

## Series Overview

By the end of this series, you’ll have:
- A secure, scalable Amazon EKS cluster.
- A production-grade VPC with optimized configurations.
- Insight into the architectural decisions that make up a SaaS infrastructure.

### Blog Link
This repository accompanies the first article in our blog series. You can read the full guide [here](https://www.waelgabsi.com/blog/building-vpc).

## Getting Started

To get started with the VPC setup:

1. **Clone this repository.**

2. **Adjust `terraform.tfvars` with your values**

   Modify the `terraform.tfvars` file to include your specific configurations, such as region, account ID, and environment.

3. **Create IAM Role `EKSClusterRole`**

   Before proceeding, you'll need to create the IAM role that Terraform will assume. Follow these steps:
   - Go to the AWS Management Console and navigate to the IAM service.
   - Create a new role with the following properties:
     - **Trusted entity**: Choose "AWS account."
     - **This account**: Select your AWS account.
     - **Require external ID**: Enter `eks`.
     - **Role name**: Set the role name to `EKSClusterRole`.
     - **Permissions**: Attach the necessary policies for managing resources in your AWS account (e.g., AmazonEKSFullAccess, AmazonEC2FullAccess).

4. **Initialize Terraform**

   Run the following command in your terminal to initialize the Terraform working directory and download the necessary provider plugins:
        
        terraform init

5. **Review the Terraform configuration**

     Take a moment to review the configuration files in the repository to understand the resources that will be created.

6. **Plan the deployment** 
    
    Generate an execution plan to preview the changes Terraform will make to your infrastructure:

        terraform plan

7. **Apply the configuration** 
    
    If the plan looks good, apply the changes to provision the VPC:

        terraform apply


8. **Confirm the changes**

 
    Type **yes** when prompted to confirm the application of the changes.

9. **Verify the VPC** 
    
    Once the apply completes, log into your AWS Management Console and navigate to the VPC section to verify that the VPC has been created successfully.

10. **Clean up (optional)** 
    
    When you're finished experimenting, you can remove the resources created by Terraform using:

        terraform destroy


By following these steps, you will have successfully set up your VPC for the SaaS application infrastructure.