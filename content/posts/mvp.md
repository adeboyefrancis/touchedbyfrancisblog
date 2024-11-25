+++
title = "📦📌 Launching MVP Start-Up Application 📦📌"
date = 2024-11-25
author = "Francis Adeboye"
draft = false
tags = ["Packer", "AMI", "Django", "Python", "PostgreSQL" , "Nginx" , "Gunicorn" , "EC2" , "Hashicorp"]
categories = ["Docs"]
+++

![Start-Up MVP App](https://github.com/user-attachments/assets/c486b40e-2b9d-4ce2-8f98-89997e0db1b1)

This week blog post, I dove deep into the world of infrastructure automation for launching a **Minimum Viable Product Application**, specifically focusing on **building custom AMIs with Packer**. 
I successfully automated the release of new versions by applying **semantic versioning**  and also automated the configuration of my AMIs with pre-installed softwares such as **Nginx, Gunicorn, PostgreSQL and  Python Virtual Environment for Django Framework  using Bash scripting**, streamlining my infrastructure setup process. 

### Building Custom AMIs with Hashicorp Packer
Leveraging **HashiCorp Packer**, I created custom AMIs using **"Image as Code"** principles, enabling consistent **multi-platform virtual machine images**. 
Initially, I faced **IAM permission** challenges during build processes. By carefully analyzing error messages, I identified and added critical missing IAM actions: **"autoscaling:DescribeLaunchConfigurations", "ec2:DescribeLaunchTemplates", and "ec2:DeleteLaunchTemplate"**. 
These additions resolved build failures and successfully enabled AMI creation.
![packer-image.pkr.hcl](https://github.com/user-attachments/assets/5fe5e4d1-690c-429f-b62a-e6943eb4fc91)
![ami-v1.0.0](https://github.com/user-attachments/assets/b8179a84-304b-4b39-b364-59fc7edd52b9)

### Launching EC2 Instances with Custom AMIs
Once the AMI was ready, the next step was to launch EC2 instances using it. I implemented a **Github Action workflow dispatch** mechanism to select the desired **AMI release version** . This approach provides flexibility for launching instances from different AMI versions and **rolling back to stable versions** if needed.
I faced a few challenges during the launch process. Initially, filtering AMIs by name didn't work as expected. I resolved this by appending a wildcard to the filter. Additionally, I encountered issues with passing variables to the Terraform script. I eventually found a workaround by using environment variables.
![ec2-deploy-job](https://github.com/user-attachments/assets/f48b4429-9a13-44d0-91a7-6ade3684d04c)
![terraform-script](https://github.com/user-attachments/assets/848920ee-7b77-496e-b1df-1678a4f661aa)
![ec2-instance](https://github.com/user-attachments/assets/92eed0eb-4c5b-420a-80c0-ad3169326556)
![terraform-cloud](https://github.com/user-attachments/assets/111b90be-f711-4cad-ab55-76f2c06e0db6)

###  Connecting to EC2 Instances with SSM
To streamline instance access, I configured **AWS Systems Manager (SSM)** by creating **instance profile** and attaching it to the running instance with the required **role, permission,SSM core policy** and integrating it directly into my Terraform script. 
This approach enabled seamless, **secure connectivity** to EC2 instances without traditional SSH methods, enhancing both **operational efficiency and security**.
![instance-profile](https://github.com/user-attachments/assets/6e6a7d90-64ff-4037-bb34-769de3fd3f03)
![SSM](https://github.com/user-attachments/assets/2354e99e-9b81-4533-94f9-61a31d2cfd00)
![session](https://github.com/user-attachments/assets/d4fb42d8-9f71-47ef-b6c4-f2d0aed185eb)

### Configuring AMIs with Bash Scripting for Automated Set-up
The final step in my infrastructure automation involved creating a **Bash script** to pre-install critical web application components. My goal was to streamline the AMI configuration by integrating **Django Framework, PostgreSQL, Nginx, Gunicorn and a Python virtual environment** into a cohesive deployment ecosystem.
My start-up web application stack integrates multiple technologies seamlessly: **Django** serves as the web framework, powered by **Gunicorn** as the **WSGI HTTP** server for efficient Python web application deployment. **Nginx** acts as a robust reverse proxy, handling client requests and directing traffic to **Gunicorn**, while **PostgreSQL** provides a powerful, **relational database backend**. The entire ecosystem is encapsulated within a **Python virtual environment**, ensuring clean **dependency management and isolation**.
During the setup, I encountered a significant challenge with database configuration. Specifically, I faced an issue with generated **Open SSL** password escaping some characters with the **sed** command in my script that prevented correct loading of database credentials from the environment variable. Through careful debugging, I identified and resolved the problem by implementing proper escaping techniques with pipes and backslash, ensuring secure and reliable database connectivity.

![image](https://github.com/user-attachments/assets/5f0cac9d-cd49-4d47-8204-c9129aa4a616)
![script-test](https://github.com/user-attachments/assets/fed78f34-1800-414d-8ad2-6cd8f7d5a8cd)
![ami-v1.01](https://github.com/user-attachments/assets/d0a4d8ea-37dc-4562-85ce-abd858c56dfb)
![github-action](https://github.com/user-attachments/assets/75fc8192-342d-4677-919c-7682daaadefd)
![new-release](https://github.com/user-attachments/assets/2a84b403-52d0-4fd2-9b9c-3faae67b89a1)
![app](https://github.com/user-attachments/assets/0c2db6f7-604c-45ca-9e61-7ed27df63e67)

## Key Takeaways

Key learnings from infrastructure automation and cloud deployment:

* **IAM Permissions:** Critical understanding of specific permissions required for infrastructure tasks
* **Troubleshooting:** Methodical debugging approach for resolving complex technical challenges
* **Automation:** Strategic use of tools like Packer and Terraform to streamline infrastructure provisioning
* **Best Practices:** Maintaining rigorous standards for security, configuration management, and version control

### Relevant links
[Installing Packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli) 

[Packer Template Documentation](https://developer.hashicorp.com/packer/docs/templates/hcl_templates/blocks)

[Mutable vs Immutable Infrastructure](https://www.hashicorp.com/resources/what-is-mutable-vs-immutable-infrastructure)



