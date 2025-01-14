+++
title = "Managed Services - Migration of Posgresql Database from Django Application using AWS DMS"
date = 2025-01-14
author = "Francis Adeboye"
draft = false
tags = ["DMS", "RDS", "SSM", "ParameterStore", "CDN" , "S3" , "PosgreSQL" , "Terraform" , "Hashicorp"]
categories = ["Docs"]
+++

![Architecture_Overview](https://github.com/user-attachments/assets/dda5bba5-88d5-4279-a3df-6cdbc5bd9eb3)

Modernizing legacy applications often starts with migrating the underlying database. This blog-post provides a practical, step-by-step guide on using **AWS Database Migration Service (DMS)** to migrate a **PostgreSQL database** from a self-managed **Django Application** server hosted on a virtual machine to **Amazon RDS**. 
This process offers significant advantages, including **reduced operational overhead**, **improved scalability**, and **enhanced security**. 
While a full modernization effort might involve other components like **storage optimization with S3 and CloudFront**, this guide focuses specifically on the crucial **database migration process using AWS DMS**, 
outlining the steps involved and highlighting the benefits of this approach.

## Database Migration to Amazon RDS

This phase migrates the existing PostgreSQL database to a managed Amazon RDS instance using AWS Database Migration Service (DMS) and Infrastructure as Code (IaC) with Terraform. This approach ensures repeatability and consistency. Key steps include:

  **Secure Credential Management:** Database credentials are securely stored and managed using AWS Systems Manager Parameter Store, ensuring sensitive information is not exposed in code. These are then used by Terraform.
  
  **Infrastructure as Code (Terraform):** I used Terraform to define and provision the necessary infrastructure, including:
    *   An RDS PostgreSQL instance (`db.t3.micro`) within the shared VPC.
    *   A DMS replication instance (`dms.t2.micro`) to handle the data transfer.
    *   An RDS Parameter Group to disable SSL temporarily for DMS, and related configurations.

  **DMS Endpoint Configuration:** Source and target endpoints were configured within DMS to connect to the existing database on the EC2 instance (accessed via SSM Session Manager for initial configuration) and the new RDS instance.

  **Security Configuration:** Security groups were configured using Terraform to allow controlled access between the EC2 instance, DMS instance, and RDS instance for database operations and replication.

**This migration establishes the foundation for the application to utilize the managed database service offered by Amazon RDS, leveraging secure credential management and IaC best practices.**
[param_store.tf](https://gist.github.com/adeboyefrancis/930d8716d8f7783862d2af6268482305)
[dms.tf](https://gist.github.com/adeboyefrancis/211d49fdc46e493caf92011b2cc32716)
[rds.tf](https://gist.github.com/adeboyefrancis/0a5fe3b880e196a8068e4cb2f5ff712a)
![rds](https://github.com/user-attachments/assets/5d10129c-c296-44e4-800d-a4bd877eb16f)
![replication_task](https://github.com/user-attachments/assets/5707da4a-e4b3-4f53-8fd0-b9eaa2395d45)
![endpoint_connection](https://github.com/user-attachments/assets/6de64913-3b98-4e6d-abe5-35722abefbec)
![task_complete](https://github.com/user-attachments/assets/26fea766-90ed-49bf-be39-c728d38861c0)
![image](https://github.com/user-attachments/assets/f045d123-174d-42ff-8efa-7cc6a208c32a)
![image](https://github.com/user-attachments/assets/16b320f6-5f52-4f01-9e97-60f46a812453)

## Storage Optimization with S3 and CloudFront

In this phase, I focused on optimizing storage and delivery of static content, specifically user-uploaded images, to improve application performance and scalability. Here's how I achieved this:

**S3 Bucket with Access Control:**

*   A secure S3 bucket named `rds-s3-image` was created to store uploaded images.
*   Origin Access Control (OAC) was enabled in the S3 bucket policy, ensuring only the CloudFront distribution can access the content. This enhances security by restricting direct public access to the bucket.
  [S3_bucket.tf](https://gist.github.com/adeboyefrancis/ed388a8f719821cc7c80134a004ee45f)
![rds-s3-image](https://github.com/user-attachments/assets/dc450450-5d68-4038-b7ef-8724869ab5d7)

**CloudFront Distribution Setup:**

*   A CloudFront distribution was configured to serve content from the S3 bucket using a unique domain name. This distribution acts as a geographically distributed cache, delivering content from edge locations closer to users, resulting in faster loading times.
[CFD_OAC.tf](https://gist.github.com/adeboyefrancis/fa7d13d6b9d07a8ec550a2a30b42ee15)

**Migrating Images to S3:**

*   Using the AWS CLI, accessed through SSM Session Manager on the EC2 instance, all existing images were securely copied from the application's media directory (`/opt/app/media/user_images`) to the designated folder (`/media/user_images`) within the S3 bucket. The following command was used:

    ```bash
    aws s3 cp /opt/app/media/user_images s3://rds-s3-image/media/user_images --recursive
    ```
    ![cli](https://github.com/user-attachments/assets/2e58c723-7002-4f15-9d73-40a2a557e0fd)


    Alternatively you can run a bash script that ensures only image files are synced to the S3 Bucket:

    ```bash
    #!/bin/bash

    # S3 Sync Script for Django Media Files

    # Define source and destination
    SOURCE_DIR="/opt/app/media"
    S3_BUCKET="s3-bucket-name"
    S3_PREFIX="/media/user_image/"

    # Sync images to S3
    aws s3 sync "$SOURCE_DIR" "s3://$S3_BUCKET$S3_PREFIX" \
        --delete \
        --exclude "*" \
        --include "*.jpg" \
        --include "*.jpeg" \
        --include "*.png" \
        --include "*.gif" \
        --include "*.webp"

    echo "Image sync completed to S3 bucket $S3_BUCKET in folder $S3_PREFIX"
    ```

*   This script ensures efficient file transfer and proper organization within the S3 bucket structure.

**EC2 Instance Profile Permissions:**

*   The EC2 instance profile was updated with appropriate permissions to interact with the S3 bucket. These permissions allow the application running on the EC2 instance to put, get, delete, and list objects within the S3 bucket, enabling seamless image management.

By implementing these steps, I successfully migrated user-uploaded images to a highly available and scalable storage solution (S3) while leveraging CloudFront's edge network for efficient content delivery, ultimately enhancing the user experience of the application.
![synced-image](https://github.com/user-attachments/assets/472bf8f3-8d1f-4ce9-b13d-db347f7c0fd2)

## Configuration Management with Parameter Store

This phase focused on implementing secure configuration management using AWS Systems Manager Parameter Store. This approach eliminates the need for storing sensitive information directly in code or scripts, enhancing security and reducing the risk of accidental exposure. Here's how I achieved this:

**Creating Parameters for Database Credentials:**

*   SSM Parameters were created within the `/cloudtalents/startup` path to securely store database credentials:
    *   `/cloudtalents/startup/secret_key`
    *   `/cloudtalents/startup/db_user`
    *   `/cloudtalents/startup/db_password`
*   Sensitive Terraform variables, established during database migration, were leveraged for the `db_user` and `db_password` parameters. A new sensitive variable was created for the `secret_key`.

**Storing S3 Bucket and CloudFront Domain Information:**

*   SSM Parameters were created to store S3 bucket and CloudFront domain information dynamically accessible by the application:
    *   `/cloudtalents/startup/image_storage_bucket_name`
    *   `/cloudtalents/startup/image_storage_cloudfront_domain`
*   Existing Terraform resources for the S3 bucket and CloudFront distribution were used to populate these parameters with the relevant values.

**Setting up RDS Endpoint Parameter:**

*   An SSM Parameter, `/cloudtalents/startup/database_endpoint`, was created to dynamically store the RDS instance endpoint retrieved from the Terraform resource.

**Configuring EC2 Instance Permissions for Parameter Access:**

*   The EC2 instance profile was updated with read permissions for all parameters under the `/cloudtalents/startup` path. This allows for future parameter additions without requiring additional IAM permission changes.

**Secure Script and Workflow Updates (Related to Configuration Management):**

*   The GitHub Actions workflow was modified to eliminate the creation of the `secrets.sh` file, ensuring sensitive information is not stored within the codebase.
*   The local setup script (`setup.sh`) was updated:
    *   All PostgreSQL-related steps (installation, configuration) were removed.
    *   References to environment variables from `secrets.sh` were eliminated.
    *   Commands related to `$APP_DIR/manage.py` were removed.
    *   The `Environment="AWS_DEFAULT_REGION=eu-west-1"` line was added to the Gunicorn service configuration. This ensures the application knows the region where the AWS resources reside. Update this region if needed.

By implementing Parameter Store, this phase significantly enhances security by centralizing sensitive configuration information and eliminating the need for hard-coded credentials. This promotes easier management and ensures secure access control.
![paramstore](https://github.com/user-attachments/assets/1341e55d-911b-4af8-80c1-3634dbf3a0af)
![terraform_workspace](https://github.com/user-attachments/assets/b9b60f02-7d77-47a2-a6d6-78114c8c33fe)

## Application Updates

This final phase focused on updating the application code to integrate with the AWS services implemented in the previous phases and deploying these changes.

**Updating Application Code for AWS Service Integration:**

*   The application code was updated to retrieve configuration values (database credentials, RDS endpoint, S3 bucket name, CloudFront domain) from AWS Systems Manager Parameter Store instead of the now-removed `secrets.sh` file. This ensures the application dynamically retrieves the necessary information at runtime.
*   The application was also updated to use the S3 bucket and CloudFront distribution for storing and serving user-uploaded images.

**Creating New GitHub Release:**

*   A new GitHub release was created to trigger a rebuild of the custom AMI with the updated application code. This automated the process of creating a deployable image with the latest changes.

**Deploying Updated AMI:**

*   The new AMI version, built from the GitHub release, was deployed. This replaced the previous EC2 instance with an instance running the updated application.

**Verifying Functionality with Existing and New Content:**

*   After deployment, the application was tested to ensure:
    *   All previously uploaded photos were accessible.
    *   New photos could be successfully uploaded and displayed.

By completing these steps, the application is now fully integrated with the AWS services (RDS, S3, CloudFront, Parameter Store) and deployed with the latest code, ensuring proper functionality and leveraging the benefits of the cloud infrastructure.
![github-actions](https://github.com/user-attachments/assets/e61b42b6-7ae8-4693-883a-1cce1ae947c5)
![new_release](https://github.com/user-attachments/assets/a90faab0-36c5-459b-8d83-d6945929fd47)
![image](https://github.com/user-attachments/assets/ee7cb15f-5056-447d-adfc-57d573b0d38b)

## Conclusion

This multi-phase migration and modernization effort has significantly improved the application's architecture and operational efficiency. By leveraging AWS managed services, I achieved the following key benefits:

*   **Enhanced scalability with managed database:** Migrating to Amazon RDS provides automatic scaling capabilities, ensuring the database can handle increasing traffic and data volumes without manual intervention.
*   **Improved performance with CDN integration:** Integrating Amazon CloudFront for content delivery dramatically improves application performance by caching static assets closer to users, reducing latency and improving load times.
*   **Secure configuration management:** Implementing AWS Systems Manager Parameter Store ensures sensitive information is securely managed and accessed, eliminating the risks associated with hardcoded credentials and improving the overall security posture.
*   **Reduced operational overhead:** By offloading database management to RDS and content delivery to CloudFront, the operational burden on the development team is significantly reduced, allowing them to focus on application development rather than infrastructure maintenance.
*   **Better resource utilization:** Using managed services optimizes resource utilization by scaling resources dynamically based on demand, avoiding over-provisioning and reducing costs.
*   **Automated maintenance and updates:** RDS and CloudFront handle routine maintenance tasks and updates automatically, ensuring the application remains secure and up-to-date with minimal effort.

This modernization process not only enhances the application's performance, security, and scalability but also lays a solid foundation for future growth and innovation.

You can find the complete code for this project on my GitHub repository: [startup-application-v1](https://github.com/adeboyefrancis/startup-application-v1.git).

## Relevant Links

- [Amazon Relational Database Service (RDS)](https://aws.amazon.com/rds/postgresql/)
- [Amazon Database Migration Service (DMS)](https://aws.amazon.com/dms/)
