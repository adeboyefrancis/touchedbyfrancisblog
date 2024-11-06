+++
title = "The Pilot 👨🏽‍✈️🌍✈️ -> Setting Up a Secure and Scalable AWS Environment with Control Tower"
date = 2024-10-07T23:45:27+02:00
author = "Francis Adeboye"
draft = false
tags = ["IAM", "LandingZone", "Control Tower", "Account Factory", "OU" , "Development"]
categories = ["Docs"]
+++

I recently set up **AWS Control Tower** to manage a multi-account environment, providing a robust foundation for isolating workloads and maintaining security and compliance. Here’s a breakdown of the process and its key components: <!--more-->


# Control Tower Setup
I configured **Control Tower**, which created **Landing Zones** to organize workloads across multiple AWS accounts, providing clear isolation and management.

# Email Aliases
Two alias email addresses were created for **Log Archives** and **Audit**, ensuring streamlined notifications and account monitoring.

# Landing Zones and Account Management
New **Landing Zones** were set up under the main AWS account, with a dedicated email address for efficient management of accounts.


# Organizational Units (OUs)
I established two **OUs**—**Security** and **Sandbox**—to segregate workloads. In total, three multi-accounts were created: **Management**, **Log**, and **Archive** for more organized account management.


# Preventive and Detective Controls
To enforce policies across accounts, I implemented **20 preventive controls**. Additionally, I set up **3 detective controls** to monitor and address configuration violations across the environment.

# Development Account
A dedicated **Development account** was created within the **Sandbox OU**, ensuring a safe and isolated environment for testing and experimentation.

# Automation and Cost Control
I deployed a **CloudShell script** to monitor **CloudTrail** configurations, preventing unnecessary costs. The script tracks **IAM resource configurations** daily across all accounts.

By leveraging **Control Tower**, **Landing Zones**, **OUs**, and **IAM Identity Center**, this setup provides centralized management, enhanced security, and adherence to industry best practices. This approach lays a strong foundation for securely and efficiently scaling AWS environments.

# Resource links
[What is a Landing Zone?](https://docs.aws.amazon.com/prescriptive-guidance/latest/migration-aws-environment/building-landing-zones.html#aws-control-tower)

[Landing Zones with AWS Control Tower](https://docs.aws.amazon.com/prescriptive-guidance/latest/migration-aws-environment/building-landing-zones.html#aws-control-tower)

<iframe src="https://giphy.com/embed/rVZEejvVWEbug" width="480" height="336" style="" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/reactiongifs-rVZEejvVWEbug">via GIPHY</a></p>
